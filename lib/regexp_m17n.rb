# encoding: utf-8
module RegexpM17N
  # See https://github.com/rails/rails/blob/4-1-2/activesupport/lib/active_support/core_ext/object/blank.rb#L102
  # and http://www.geocities.jp/kosako3/oniguruma/doc/RE.txt
  #
  #   # A string is blank if it's empty or contains whitespaces only:
  #
  #   ''.blank?       # => true
  #   '   '.blank?    # => true
  #   "\t\n\r".blank? # => true
  #   ' blah '.blank? # => false
  #
  # Unicode whitespace is supported:
  #
  #   "\u00a0".blank? # => true
  #   ''.blank?       # => true
  #   '   '.blank?    # => true
  #   "\t\n\r".blank? # => true
  #   ' blah '.blank? # => false
  #
  # Unicode whitespace is supported:
  #
  #   "\u00a0".blank? # => true

  BLANK_RE = /\A[[:space:]]*\z/

  module_function

  def non_empty?(str)
    ! empty?(str)
  end

  def empty?(str)
    fail TypeError.new("#{str.inspect} is not a string") unless str.is_a?(String)
    BLANK_RE === str.dup.force_encoding(Encoding::UTF_8)
  rescue ArgumentError
    debug "Could not determine if #{str.inspect} is empty due to #{$!.message}. Assuming it has content"
    false
  end

  def encode_string!(test_str, enc)
    ec = Encoding::Converter.new(enc, Encoding::UTF_8)
    ec.convert(test_str)
    test_str = ec.finish.dump
  rescue Encoding::UndefinedConversionError, Encoding::InvalidByteSequenceError
    debug "Conversion failed #{ec.last_error}"
    if new_enc = Encoding::Converter.asciicompat_encoding(enc)
      debug "Converting from #{enc} to ascii compat encoding #{new_enc}"
      test_str = test_str.encode(new_enc)
    else
      debug "Forcing encoding #{enc}"
      test_str = test_str.force_encoding(enc)
    end
  rescue Encoding::ConverterNotFoundError
      debug "No converter found for #{enc}"
  ensure
    return test_str
  end

  def debug(msg)
    return unless $DEBUG
    warn msg
  end

end
