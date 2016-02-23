# encoding: utf-8
require 'spec_helper'
require 'logstash/filters/japanese_pos'

describe LogStash::Filters::JapanesePos do
  describe "Add POS info" do
    let(:config) do
      <<-CONFIG
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
      tag = subject['pos'][0]
      expect(tag[:value]).to eq('写真')
      expect(tag[:field]).to eq('message')
      expect(tag[:positions].size).to eq(1)
      expect(tag[:positions][0]).to eq(0)
      expect(tag[:pos][:pos1]).to eq('名詞')
      expect(tag[:pos][:pos2]).to eq('一般')
      expect(tag[:pos][:pos3]).to eq('*')
      expect(tag[:pos][:pos4]).to eq('*')
      tag = subject['pos'][1]
      expect(tag[:value]).to eq('宿題')
      expect(tag[:field]).to eq('message')
      expect(tag[:positions].size).to eq(1)
      expect(tag[:positions][0]).to eq(1)
      expect(tag[:pos][:pos1]).to eq('名詞')
      expect(tag[:pos][:pos2]).to eq('サ変接続')
      expect(tag[:pos][:pos3]).to eq('*')
      expect(tag[:pos][:pos4]).to eq('*')
    end
  end

  describe "Skip end of line characters." do
    let(:config) do
      <<-CONFIG
      filter {
        japanese_pos {
          fields => ['message']
          output_field => 'pos'
        }
      }
      CONFIG
    end

    sample("message" => "ケーキはとっても美味しかったです。\n") do
      expect(subject).to include("pos")
      expect(subject['pos'].size).to eq(3)
      expect(subject['pos'][0][:value]).to eq('ケーキ')
      expect(subject['pos'][1][:value]).to eq('とっても')
      expect(subject['pos'][2][:value]).to eq('美味しい')
    end
  end

  describe "Persist all postions of a token." do
    let(:config) do
      <<-CONFIG
      filter {
        japanese_pos {
          fields => ['message']
          output_field => 'pos'
        }
      }
      CONFIG
    end

    sample("message" => "ケーキはとっても美味しかったです。私はケーキが大好きです。") do
      expect(subject).to include("pos")
      expect(subject['pos'].size).to eq(5)
      expect(subject['pos'][0][:value]).to eq('ケーキ')
      expect(subject['pos'][0][:positions]).to eq([0,4])
    end
  end

  describe "Use dynamic fields" do
    fields = ["field1"]
    config <<-CONFIG
      filter {
        japanese_pos {
          fields => "%{fields}"
        }
      }
    CONFIG

    sample("field1" => "写真はイメージです", "fields" => fields) do
      expect(subject).to include("words")
      expect(subject['words'].size).to eq(2)
    end
  end


end
