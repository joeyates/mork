# frozen_string_literal: true

require "mork/lexer"

module Mork
  RSpec.describe Lexer do
    let(:mork_pathname) { "spec/fixtures/Foo.msf" }
    let(:content) { File.read(mork_pathname) }
    let(:all) do
      all = []
      loop do
        token = subject.next_token
        break if !token

        all << token
      end
      all
    end

    before do
      subject.scan_setup(content)
    end

    describe "#next_token" do
      it "returns the Mork magic header" do
        expect(subject.next_token).to match([:magic, /mdb:mork/])
      end

      it "splits the file into tokens" do
        expect(all.count).to be > 900
      end
    end
  end
end
