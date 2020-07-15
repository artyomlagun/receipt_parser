module ReceiptParser
  class OfdOneParser < EReceiptParser
    def initialize(params)
      @fd = params[:i]
      @fn = params[:fn]
      @fp = params[:fp]
    end


    def parse
      super() do |response|
        LogService.log("OfdOneParser: #{response[:body]}")
        response_body = JSON.parse(response[:body])
        if response_body['status'] == 2
          raise InvalidReceiptError
        else
          res = ReceiptParser::HttpClient.instance.get(get_ticket_url(response_body['uid']), nil, {}, nil)
          encoded_res = JSON.parse(res[:body].force_encoding('UTF-8'))
          File.open("#{Rails.root}/response_ofd_one.json", 'w+') do |file|
            file << encoded_res
            file.close
          end
          receipt_items = encoded_res['ticket']['items'].map do |item|
            ReceiptParser::ReceiptItem.new(item['name'], item['quantity'], item['price'])
          end
          ReceiptParser::Receipt.new(receipt_items, @fp, @fd, @fn, encoded_res['ticket']['user'])
        end
      end
    end


    protected

    def http_method
      ReceiptParser::HttpClient::HTTP_METHOD_POST
    end

    def ofd_url
      URI(ReceiptParser.ofd_one_ru[:url])
    end

    def get_ticket_url(uid)
      URI("https://consumer.1-ofd.ru/api/tickets/ticket/#{uid}")
    end

    def headers
      {"Content-Type": "application/json"}
    end

    def payload
      {
        "fiscalDocumentNumber": @fd.to_s,
        "fiscalDriveId": @fn.to_s,
        "fiscalId": @fp.to_s,
        "requestDate": DateTime.now.to_i.to_s
      }
    end

  end
end
