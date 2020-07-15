Rails.application.routes.draw do
  mount ReceiptParser::Engine => "/receipt_parser"
end
