# frozen_string_literal: true

module EmailForwardParser
  class Utils
    class << self
      # Executes multiple regular expressions until one succeeds
      # @param regexes [Array<Regexp, String>] Array of regexes or regex strings
      # @param str [String] The string to match against
      # @param mode [String] The mode of operation ('match', 'split', or 'replace')
      # @param highest_position [Boolean] Whether to find the highest position match
      # @return [Array, String] The result of the first successful regular expression
      def loop_regexes(regexes, str, mode = "match", highest_position = true)
        match = nil
        min_length = mode == "split" ? 1 : 0
        max_length = str.length

        regexes.each do |regex|
          regex = Regexp.new(regex) if regex.is_a?(String)

          current_match = case mode
                          when "match"
                            str.match(regex)
                          when "split"
                            str.split(regex)
                          when "replace"
                            str.gsub(regex, "")
                          end || ""

          if mode == "replace"
            match = current_match
            break if match.length < max_length
          elsif %w[split match].include?(mode)
            if (current_match || []).length > min_length
              if highest_position
                if !match
                  match = current_match
                else
                  higher = if mode == "match"
                             match.begin(0) > current_match.begin(0)
                           else
                             match[0].length > current_match[0].length
                           end
                  match = current_match if higher
                end
              else
                match = current_match
                break
              end
            end
          end
        end

        mode == "replace" ? (match || "") : (match || [])
      end

      # Reconciliates match substrings after a "split" operation
      # @param match [Array] The match result
      # @param min_substrings [Integer] Minimum number of substrings
      # @param default_substrings [Array<Integer>] Indices of default substrings
      # @param exclude_proc [Proc] Optional proc to determine substring exclusion
      # @return [String] The reconciliated string
      def reconciliate_split_match(match, min_substrings, default_substrings, exclude_proc = nil)
        str = ""

        default_substrings.each do |index|
          str += match[index]
        end

        if match.length > min_substrings
          (min_substrings...match.length).each do |i|
            exclude = exclude_proc&.call(i)
            str += match[i] unless exclude
          end
        end

        str
      end

      # Trims a string
      # @param str [String] The string to trim
      # @return [String] The trimmed string
      def trim_string(str)
        (str || "").strip
      end
    end
  end
end
