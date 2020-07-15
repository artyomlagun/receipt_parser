module ReceiptParser
  class ReceiptsService
    def initialize(params)
      @params = params
    end

    def parse
      @parser = ReceiptParser.default_parser.constantize.new(@params).parse
    end

    def search

    end
  end
end
