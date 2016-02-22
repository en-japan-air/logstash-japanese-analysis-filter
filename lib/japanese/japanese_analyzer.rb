# encoding: utf-8
require 'natto'
require 'load_jars'

# Analyzer of Japanese string data
class JapaneseAnalyzer

  def initialize(ignore_pos=%w(助詞 助動詞 記号 終助詞), options={})
    @mecabs = {}
    @mecab_options = options
    # Pos to be skipped during parsing
    @ignore_pos = ignore_pos
  end

  def analyze(text)
    tokenizer = Java::com.enjapan.preprocessing.japanese.tokenizers.KuromojiTokenizer.new(
        Java::com.atilika.kuromoji.ipadic::Tokenizer.new,
        Java::scala.collection.immutable::Set.empty,
        Java::scala.collection.immutable::Set.empty,
        Java::scala.collection::Set.empty.
            +(Java::scala.collection.immutable::List.empty.send("::", "助詞")).
            +(Java::scala.collection.immutable::List.empty.send("::", "助動詞")).
            +(Java::scala.collection.immutable::List.empty.send("::", "記号")).
            +(Java::scala.collection.immutable::List.empty.send("::", "終助詞"))
    )

    result = {}
    i = 0
    tokenized = Java::scala.collection.JavaConversions.seqAsJavaList(tokenizer.tokenizeWithMetadata(text)).to_a
    tokenized.each do |t|
      surface = t.getSurface
      unless result.key?(surface)
        result[surface] = {
          pos: [ :pos1 => t.getPartOfSpeechLevel1,
                 :pos2 => t.getPartOfSpeechLevel2,
                 :pos3 => t.getPartOfSpeechLevel3,
                 :pos4 => t.getPartOfSpeechLevel4],
          positions: []
        }
      end
      result[surface][:positions] << i
      i += 1
    end
    result
  end
end
