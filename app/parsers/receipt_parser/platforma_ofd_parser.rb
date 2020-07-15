module ReceiptParser
  class PlatformaOfdParser < EReceiptParser
    def initialize(params)
      @fn = params[:fn]
      @fp = params[:fp]
      @fd = params[:i]
    end

    def parse
      super() do |response|
        LogService.log("PlatformaOfdParser: #{response[:body]}")
        response = response[:body].force_encoding('UTF-8')
        html_doc = Nokogiri::HTML(response)
        receipt_user = html_doc.search(ReceiptParser.platforma_ofd_ru[:xpath][:user])
        receipt_products = html_doc.search(ReceiptParser.platforma_ofd_ru[:xpath][:products])
        if receipt_products.empty?
          raise InvalidReceiptError, 'The ticket was not found'
        else
          receipt_items = receipt_products.map do |prod|
            quantity_x_price = prod.search(ReceiptParser.platforma_ofd_ru[:xpath][:quantity])[0].children.text.split(' х ')
            ReceiptParser::ReceiptItem.new(
              prod.search(ReceiptParser.platforma_ofd_ru[:xpath][:item]).children.text,
              quantity_x_price[0],
              quantity_x_price[1]
            )
          end
          if receipt_user.empty?
            receipt_user = ''
          else
            receipt_user = receipt_user.children.first.text
          end
          ReceiptParser::Receipt.new(receipt_items, @fp, @fd, @fn, receipt_user)
        end
      end
    end

    protected

    def ofd_url
      URI(ReceiptParser.platforma_ofd_ru[:url] % {fn: @fn, fp: @fp, fd: @fd})
    end

  end
end
