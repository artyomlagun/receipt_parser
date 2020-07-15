ReceiptParser::Engine.routes.draw do
  post '/parse', to: 'receipts#parse', as: :parse
  post '/search', to: 'receipts#search', as: :search
end
