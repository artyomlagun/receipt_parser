module ReceiptParser
  class ReceiptsController < ApplicationController
    def parse
      respond_to do |format|
        format.html
        format.json {render json: ReceiptParser::ReceiptsService.new(params[:receipt_info]).parse.to_json}
      end
    end

    def search

    end
  end
end
