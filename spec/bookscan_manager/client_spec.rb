require "spec_helper"

describe BookscanManager::Client do
  let(:config) { {} }
  let(:client) { BookscanManager::Client.new(config) }

  describe "#list" do
    subject { client.parse_showbook_link(link) }

    context "with valid link" do
      let(:link) { "showbook.php?h=deadbeef&d=cafebabe&f=hoge.pdf&hoge=fuga" }

      it "returns book info" do
        expect(subject.hash).to eq("deadbeef")
        expect(subject.digest).to eq("cafebabe")
        expect(subject.filename).to eq("hoge.pdf")
      end
    end

    context "with invalid link" do
      let(:link) { "hoge" }

      it "returns nil" do
        expect(subject).to eq(nil)
      end
    end
  end
end
