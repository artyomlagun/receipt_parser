module ReceiptParser
  class NvgParser < EReceiptParser
    def initialize(params)
      @fp = params[:fp]
      @sum = params[:s]
    end

    def parse
      super() do |response|
        LogService.log("NvgParser: #{response[:body]}") unless response.nil?
        response_body = JSON.parse(response[:body])  unless response.nil?
        if response.nil? || response_body == []
          raise InvalidReceiptError
        else
          # receipt_items = response.map {|item| ReceiptParser::ReceiptItem.new(item['name'], item['quantity'], item['price'])}
          # ReceiptParser::Receipt.new(response, @fp)
          response[:body]
        end
      end
    end

    protected

    def ofd_url
      URI(ReceiptParser.nvg_ru[:url] % {sum: @sum, fp: @fp})
    end

  end
end
