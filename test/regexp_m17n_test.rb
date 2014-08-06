# encoding: utf-8
require 'minitest/autorun'
require_relative '../lib/regexp_m17n'

class RegexpTest < MiniTest::Unit::TestCase

  def test_non_empty_string
    Encoding.list.each do |enc|
      test_str = RegexpM17N.encode_string!('.', enc)
      puts "Testing #{enc} against #{test_str.valid_encoding? ? 'valid' : 'invalid'} encoding #{test_str.encoding}"
      assert(RegexpM17N.non_empty?(test_str))
    end
  end

end
