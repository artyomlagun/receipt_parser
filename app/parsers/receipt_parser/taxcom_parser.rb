module ReceiptParser
  class TaxcomParser < EReceiptParser
    def initialize(params)
      @fp = params[:fp]
      @sum = params[:s]
    end

    def parse
      super() do |response|
        LogService.log("TaxcomParser: #{response[:body]}") unless response.nil?
        response = response[:body].force_encoding('UTF-8')
        html_doc = Nokogiri::HTML("#{response}")
        xpath = ReceiptParser.taxcom_ru[:xpath]
        not_found = html_doc.search(xpath[:not_found])[0]
        if not_found
          raise InvalidReceiptError, not_found.content
        else
          receipt_user = html_doc.search(xpath[:user]).children.first.text
          receipt_products = html_doc.search(xpath[:products])
          receipt_items = receipt_products.map do |prod|
            quantity_x_price = prod.search(xpath[:quantity])
            unless prod.search(xpath[:item]).blank?
              ReceiptParser::ReceiptItem.new(prod.search(xpath[:item]).children.text, quantity_x_price[0].children.text, quantity_x_price[1].children.text)
            end
          end
          ReceiptParser::Receipt.new(receipt_items, @fp, nil, nil, receipt_user)
        end
      end
    end

    protected

    def ofd_url
      URI(ReceiptParser.taxcom_ru[:url] % {fp: @fp, sum: @sum})
    end

  end
end
# /?fp=1839290172s
