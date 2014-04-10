require "mechanize"
l
module BookscanManager
  class Client
    def initialize(config)
      @username = config["username"]
      @password = config["password"]
      @pdf_directory = config["pdf_directory"]
      @mechanize = Mechanize.new
    end

    def list
      binding.pry
    end

    LINK_REGEXP = /showbook.php\?h=(.+)&d=(.+)&f=(.+)$/.freeze

    def parse_book_info_link(link)
      matcher = LINK_REGEXP.match(link) or return
      BookscanManager::Model::BookInfo.new(matcher[1], matcher[2], matcher[3])
    end
  end
end
