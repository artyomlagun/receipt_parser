module ReceiptParser
  class CompositeEReceiptParser < Base
    def initialize(params)
      @params = params
      @parsers = ReceiptParser.receipt_e_parsers
    end

    def parse
      result = nil
      @parsers.each do |parser|
        begin
          LogService.log("TIME: #{DateTime.now}")
          LogService.log("PARSER: #{parser}")
          result = parser.constantize.new(@params).parse
          LogService.log("RESULT: #{result}")
          return result if result
        rescue InvalidReceiptError
          #do nothing
        end
      end
      result ? result : raise(InvalidReceiptError)
    end
  end
end
