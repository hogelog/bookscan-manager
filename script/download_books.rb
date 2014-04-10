#!/usr/bin/env ruby

require "pit"
require_relative "../lib/bookscan_manager"

config = Pit.get("bookscan_manager", require: {
  "username" => "bookscan username (email)",
  "password" => "bookscan password",
  "pdf_directory" => "./pdf",
})

client = BookscanManager::Client.new(config)

client.download_all
