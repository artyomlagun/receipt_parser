module ReceiptParser
  class Receipt < Struct.new(:items, :fiscal_id, :fiscal_document_number, :fiscal_drive_id, :user, :date)
  end
end
