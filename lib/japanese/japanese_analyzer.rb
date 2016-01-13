# encoding: utf-8
require 'natto'

# Analyzer of Japanese string data
class JapaneseAnalyzer

  def initialize(ignore_pos=%w(助詞 助動詞 記号 終助詞), options={})
    @mecabs = {}
    @mecab_options = options
    # Pos to be skipped during parsing
    @ignore_pos = ignore_pos
  end

  def analyze(text)
    mecab = @mecabs[Thread.current] ||= Natto::MeCab.new(@mecab_options)

    result = {}
    i = 0
    mecab.parse(text) do |t|
      surface = t.surface
      pos = t.feature.split(',')[0]
      next if t.is_eos? || t.stat != 0 || t.char_type == 3 || @ignore_pos.include?(pos)
      unless result.key?(surface)
        result[surface] = {
          pos: pos,
          positions: []
        }
      end
      result[surface][:positions] << i
      i += 1
    end
    result
  end
end
