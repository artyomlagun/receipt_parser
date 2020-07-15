module ReceiptParser
  class RequestError < ::RuntimeError
  end

  class EReceiptParser < Base

    def parse
      response = self.lookup_receipt
      response = yield response if block_given?
      response
    end

    protected

    def http_method
      ReceiptParser::HttpClient::HTTP_METHOD_GET
    end

    def ofd_url
      raise NotImplementedError
    end

    def headers
      {}
    end

    def payload
      nil
    end

    def lookup_receipt
      ReceiptParser::HttpClient.instance.send(http_method, ofd_url, payload, headers, payload)
    end

  end
end
