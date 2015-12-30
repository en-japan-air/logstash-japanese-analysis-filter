# encoding: utf-8
require 'spec_helper'
require 'logstash/filters/japanese_pos'

describe LogStash::Filters::JapanesePos do
  describe "Add POS info" do
    let(:config) do <<-CONFIG
      filter {
        japanese_pos {
          fields => ['message']
          output_field => 'pos'
        }
      }
    CONFIG
    end

    sample("message" => "写真の宿題") do
      expect(subject).to include("pos")
      expect(subject['pos'].size).to eq(2)
    end
  end
end
