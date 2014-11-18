require "logstash/devutils/rspec/spec_helper"
require "logstash/filters/json_encode"

describe LogStash::Filters::JSONEncode do


  describe "encode a field as json" do
    config <<-CONFIG
      filter {
        json_encode {
          source => "hello"
          target => "fancy"
        }
      }
    CONFIG

    hash = { "hello" => { "whoa" => [ 1, 2, 3 ] } }
    sample(hash) do
      insist { subject["fancy"] } == LogStash::Json.dump(hash["hello"])
    end
  end

  describe "encode a field as json and overwrite the original" do
    config <<-CONFIG
      filter {
        json_encode {
          source => "hello"
        }
      }
    CONFIG

    hash = { "hello" => { "whoa" => [ 1, 2, 3 ] } }
    sample(hash) do
      insist { subject["hello"] } == LogStash::Json.dump(hash["hello"])
    end
  end
end
