module ReceiptParser
  class KonturParser < EReceiptParser
    def initialize(params)
      @fn = params[:fn]
      @fp = params[:fp]
      @fd = params[:i]
    end

    def parse
      super() do |response|
        LogService.log("KonturParser: #{response[:body]}")
        response_body = response[:body].force_encoding('UTF-8')
        if response_body["errorCode"]
          raise InvalidReceiptError, response_body['message']
        else
          # receipt_items = response.map {|item| ReceiptParser::ReceiptItem.new(item['name'], item['quantity'], item['price'])}
          # ReceiptParser::Receipt.new(response, @fp, @fd, @fn)
          nil
        end
      end
    end

    protected

    def ofd_url
      URI(ReceiptParser.kontur_ru[:url] % {fp: @fp, fn: @fn, fd: @fd})
    end

  end
end
