module RubySpeech
  module GRXML
    ##
    #
    # The item element is one of the valid expansion elements for the SGR rule element
    #
    #   http://www.w3.org/TR/speech-grammar/#S2.4 --> XML Form
    #
    # The item element has four (optional) attributes: weight, repeat, repeat-prob, and xml:lang (language identifier)
    #
    #   http://www.w3.org/TR/speech-grammar/#S2.4.1
    #   http://www.w3.org/TR/speech-grammar/#S2.3
    #
    # A weight may be optionally provided for any number of alternatives in an alternative expansion. Weights are simple positive floating point values without exponentials. Legal formats are "n", "n.", ".n" and "n.n" where "n" is a sequence of one or many digits.
    #
    # A weight is nominally a multiplying factor in the likelihood domain of a speech recognition search. A weight of 1.0 is equivalent to providing no weight at all. A weight greater than "1.0" positively biases the alternative and a weight less than "1.0" negatively biases the alternative.
    #
    # repeat has several valid values...
    #
    # Any repeated legal rule expansion is itself a legal rule expansion.
    #
    # Operators are provided that define a legal rule expansion as being another sub-expansion that is optional, that is repeated zero or more times, that is repeated one or more times, or that is repeated some range of times.
    #
    # repeat probability (repeat-prob)  indicates the probability of successive repetition of the repeated expansion.  It is ignored if repeat is not specified
    #
    # xml:lang declares declaration declares the language of the grammar section for the item element just as xml:lang in the <grammar> element declares for the entire document
    #
    class Item < Element

      register :item

      VALID_CHILD_TYPES = [Nokogiri::XML::Element, Nokogiri::XML::Text, OneOf, Item, String, Ruleref, Tag].freeze

      ##
      # Create a new GRXML item element
      #
      # @param [Hash] atts Key-value pairs of options mapping to setter methods
      #
      # @return [Item] an element for use in an GRXML document
      #
      def self.new(atts = {}, &block)
        super 'item', atts, &block
      end

      ##
      #
      # The optional weight attribute
      #
      # @return [Float]
      #
      def weight
        read_attr :weight, :to_f
      end

      ##
      #
      # The weight attribute takes a positive (floating point) number
      # NOTE: the standard says a format of "n" is valid (eg. an Integer)
      # TODO: possibly support string and check to see if its a valid digit with regex...
      #
      # @param [Numeric] w
      #
      def weight=(w)
        raise ArgumentError, "A Item's weight attribute must be a positive floating point number" unless w.is_a?(Numeric)  && w >= 0
        write_attr :weight, w.to_s
      end

      ##
      #
      # The repeat attribute
      #
      # @return [String]
      #
      def repeat
        read_attr :repeat
      end

      ##
      #
      # TODO: Raise ArgumentError after doing checking.  See
      #       http://www.w3.org/TR/speech-grammar/#S2.5
      #
      # @param [String] r
      #
      def repeat=(r)
        write_attr :repeat, r
      end

      ##
      #
      # The optional repeat-prob attribute
      #
      # @return [Float]
      #
      def repeat_prob
        read_attr :'repeat-prob', :to_f
      end

      ##
      # @param [Numeric] ia
      #
      def repeat_prob=(rp)
        raise ArgumentError, "A Item's repeat probablity attribute must be a floating point number between 0.0 and 1.0" unless rp.is_a?(Numeric)  && rp >= 0 && rp <= 1.0
        write_attr :'repeat-prob', rp.to_s
      end

      def <<(arg)
        raise InvalidChildError, "A Item can only accept String, Ruleref, Tag as children" unless VALID_CHILD_TYPES.include? arg.class
        super
      end

      def eql?(o)
        super o, :weight, :repeat, :language
      end
    end # Item
  end # GRXML
end # RubySpeech
