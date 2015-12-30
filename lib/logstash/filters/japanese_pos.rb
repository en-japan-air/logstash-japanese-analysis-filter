# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"

require 'japanese/japanese_analyzer'

# This example filter will replace the contents of the default 
# message field with whatever you specify in the configuration.
#
# It is only intended to be used as an example.
class LogStash::Filters::JapanesePos < LogStash::Filters::Base

  # Setting the config_name here is required. This is how you
  # configure this filter from your Logstash config.
  #
  # filter {
  #   japanse_pos {
  #     message => "My message..."
  #   }
  # }
  #
  config_name "japanese_pos"
  
  # Fields to analyze
  config :fields, :validate => :array
  config :output_field, :validate => :string, :default => 'words'
  config :ignore_pos, :validate => :array, :default => %w(助詞 助動詞 記号 終助詞)
  config :with_positions, :validate => :boolean, :default => true
  config :dic_dir, :validate => :string

  public
  def register
    options = @dic_dir ? { :dicdir => @dic_dir } : {}
    @analyzer = JapaneseAnalyzer.new(@ignore_pos, options)
  end # def register

  public
  def filter(event)
    pos = @fields.map do |field|
      text = event[field]
      next if text.nil? || text.empty?
      analyzed_hash = @analyzer.analyze(text)
      analyzed_hash.map do |key, value|
        value.delete(:positions) unless @with_positions
        value.merge(value: key.to_s, field: field.to_s)
      end
    end.flatten

    event[@output_field] = pos unless pos.empty?

    # filter_matched should go in the last line of our successful code
    filter_matched(event)
  end # def filter
end # class LogStash::Filters::Example
