# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"
require "logstash/environment"
require "logstash/json"

# JSON encode filter. Takes a field and serializes it into JSON
#
# If no target is specified, the source field is overwritten with the JSON
# text.
#
# For example, if you have a field named `foo`, and you want to store the
# JSON encoded string in `bar`, do this:
# [source,ruby]
#     filter {
#       json_encode {
#         source => "foo"
#         target => "bar"
#       }
#     }
class LogStash::Filters::JSONEncode < LogStash::Filters::Base

  config_name "json_encode"

  # The field to convert to JSON.
  config :source, :validate => :string, :required => true

  # The field to write the JSON into. If not specified, the source
  # field will be overwritten.
  config :target, :validate => :string

  public
  def register
    @target = @source if @target.nil?
  end # def register

  public
  def filter(event)

    @logger.debug? && @logger.debug("Running JSON encoder", :event => event)
    raw = event.get(@source)
    begin
      event.set(@target, LogStash::Json.dump(raw))
      filter_matched(event)
    rescue => e
      event.tag "_jsongeneratefailure"
      @logger.warn("Trouble encoding JSON", :source => @source, :raw => raw.inspect, :exception => e)
    end

    @logger.debug? && @logger.debug("Event after JSON encoder", :event => event)
  end # def filter
end # class LogStash::Filters::JSONEncode
