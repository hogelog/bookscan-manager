module BookscanManager
  module Model
    class BookInfo
      attr_accessor :hash, :digest, :filename

      def initialize(hash, digest, filename)
        self.hash = hash
        self.digest = digest
        self.filename = filename
      end
    end
  end
end
