module ReceiptParser
  class ReceiptItem < Struct.new(:name, :quantity, :price)
  end
end
