# encoding: utf-8
require 'natto'
require 'load_jars'
require 'set'

# Analyzer of Japanese string data
class JapaneseAnalyzer

  def initialize(ignore_pos=%w(助詞 助動詞 記号 終助詞), ignore_words=Set.new)
    stop_pos = Java::scala.collection::Set.empty
    ignore_pos.each do |pos|
      stop_pos = stop_pos.+(Java::scala.collection.immutable::List.empty.send("::", pos))
    end

    stopwords = Java::scala.collection.immutable::Set.empty
    ignore_words.each do |word|
      stopwords = stop_pos.+(word)
    end

    @tokenizer = Java::com.enjapan.preprocessing.japanese.tokenizers.KuromojiTokenizer.new(
        Java::com.atilika.kuromoji.ipadic::Tokenizer.new,
        stopwords,
        Java::scala.collection.immutable::Set.empty,
        stop_pos)
  end

  def analyze(text)
    result = {}
    i = 0
    tokenized = Java::scala.collection.JavaConversions.seqAsJavaList(@tokenizer.tokenizeWithMetadata(text)).to_a
    tokenized.each do |t|
      surface = t.getBaseForm
      unless result.key?(surface)
        result[surface] = {
          pos: { :pos1 => t.getPartOfSpeechLevel1,
                 :pos2 => t.getPartOfSpeechLevel2,
                 :pos3 => t.getPartOfSpeechLevel3,
                 :pos4 => t.getPartOfSpeechLevel4},
          positions: []
        }
      end
      result[surface][:positions] << i
      i += 1
    end
    result
  end
end
