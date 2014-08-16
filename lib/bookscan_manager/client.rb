require "mechanize"
require "uri"
require "rack"
require "logger"
require "pry"

module BookscanManager
  class Client

    BOOKSCAN_HOST = "https://system.bookscan.co.jp"

    DEFAULT_SLEEP = 0.5

    def initialize(config)
      @username = config["username"]
      @password = config["password"]
      @pdf_directory = config["pdf_directory"]
      @mechanize = Mechanize.new
      @logger = Logger.new(STDOUT)
      @sleep = DEFAULT_SLEEP

      self.login
    end

    def login
      login_page = @mechanize.get("#{BOOKSCAN_HOST}/login.php")
      login_page.form_with do |form|
        form.field_with(name: "email").value = @username
        form.field_with(name: "password").value = @password
        form.click_button
      end
    end

    def list
      books = []
      pagenum = 1
      loop do
        page = @mechanize.get("#{BOOKSCAN_HOST}/bookshelf_all_list.php?page=#{pagenum}")
        links = page.search('a[href^="showbook.php"]')
        break if links.size == 0
        books += links.map{|link| parse_showbook_link(link[:href]) }
        pagenum += 1
        sleep(@sleep)
      end
      books
    end

    def download(book, directory: "./")
      default_parse = @mechanize.pluggable_parser.default
      begin
        @mechanize.pluggable_parser.default = Mechanize::Download
        pdf_path = File.join(directory, URI.unescape(book.filename))
        if File.exist?(pdf_path)
          @logger.info("#{pdf_path} exists")
        else
          @logger.info("downloading #{pdf_path}")
          @mechanize.get("#{BOOKSCAN_HOST}/download.php?d=#{book.digest}&f=#{book.filename}").save(pdf_path)
          sleep(0.5)
        end
      ensure
        @mechanize.pluggable_parser.default = default_parse
      end
    end

    def parse_showbook_link(link)
      query = Rack::Utils.parse_query(URI.parse(link).query)
      return unless query["h"] && query["d"] && query["f"]
      BookscanManager::Model::BookInfo.new(query["h"], query["d"], query["f"])
    end
  end
end
