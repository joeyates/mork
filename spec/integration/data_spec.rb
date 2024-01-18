# frozen_string_literal: true

require "mork/parser"

RSpec.describe "mork parsing" do
  let(:parser) { Mork::Parser.new }
  let(:mork_pathname) { "spec/fixtures/Foo.msf" }
  let(:content) { File.read(mork_pathname) }
  let(:raw) { parser.parse(content) }
  let(:data) { raw.data }
  let(:expected_rows) do
    [
      {
        "children" => "1",
        "threadFlags" => "0",
        "threadId" => "3",
        "threadNewestMsgDate" => "65a65937",
        "threadRoot" => "3",
        "unreadChildren" => "1"
      },
      {
        "children" => "1",
        "threadFlags" => "0",
        "threadId" => "4",
        "threadNewestMsgDate" => "65a6591b",
        "threadRoot" => "4"
      }
    ]
  end
  let(:expected_tables) do
    {
      "ns:msg:db:row:scope:dbfolderinfo:all" => {
        "1" => [
          {
            "MRMTime" => "1705400647", "MRUTime" => "1705400695", "UIDValidity" => "65",
            "applyToFlaggedMessages" => "0", "cleanupBodies" => "0", "daysToKeepBodies" => "0",
            "daysToKeepHdrs" => "1e", "expungedBytes" => "9764", "fixedBadRefThreading" => "1",
            "flags" => "8082014", "forceReparse" => "0", "highWaterKey" => "4",
            "highestModSeq" => "5326076", "highestRecordedUID" => "4", "imapFlags" => "e000",
            "mailboxName" => "Foo", "numHdrsToKeep" => "7d0", "numMsgs" => "2", "numNewMsgs" => "1",
            "onlineName" => "Foo", "retainBy" => "1", "sortColumns" => "$121", "sortOrder" => "1",
            "sortType" => "12", "totPendingMsgs" => "0", "unreadPendingMsgs" => "0",
            "useServerDefaults" => "1", "useServerRetention" => "1", "version" => "1",
            "viewFlags" => "1", "viewType" => "0"
          }
        ]
      },
      "ns:msg:db:row:scope:msgs:all" => {
        "1" => [
          {
            "ProtoThreadFlags" => "0", "X-GM-LABELS" => "", "X-GM-MSGID" => "1788242173500958345",
            "X-GM-THRID" => "1788242173500958345", "date" => "65a65937",
            "dateReceived" => "65a65937", "flags" => "80", "gloda-id" => "5973",
            "keywords" => "", "message-id" => "e2d126c338dc2a6e46f20eba5b060d8d@example.com",
            "msgCharSet" => "US-ASCII", "msgOffset" => "0", "msgThreadId" => "3",
            "offlineMsgSize" => "106d", "preview" => "", "priority" => "1",
            "recipients" => "you@example.com", "sender" => "me@example.com",
            "sender_name" => "0|me@example.com", "size" => "1066", "storeToken" => "0",
            "subject" => "Message 2", "threadParent" => "ffffffff"
          },
          {
            "ProtoThreadFlags" => "0", "X-GM-LABELS" => "", "X-GM-MSGID" => "1788242144743756366",
            "X-GM-THRID" => "1788242144743756366", "date" => "65a6591b",
            "dateReceived" => "65a6591b", "flags" => "81", "gloda-dirty" => "0",
            "gloda-id" => "5972", "keywords" => "",
            "message-id" => "bc1fbc64fc772dc0fcea58b506cecc96@example.com",
            "msgCharSet" => "US-ASCII", "msgOffset" => "106d", "msgThreadId" => "4",
            "offlineMsgSize" => "106b", "preview" => "", "priority" => "1",
            "recipients" => "you@example.com", "sender" => "me@example.com",
            "sender_name" => "0|me@example.com", "size" => "1064", "storeToken" => "4205",
            "subject" => "Message 1", "threadParent" => "ffffffff"
          }
        ],
        "3" => [],
        "4" => []
      }
    }
  end

  it "handles top-level rows" do
    expect(data.rows).to eq(expected_rows)
  end

  it "handles tables" do
    expect(data.tables).to eq(expected_tables)
  end
end
