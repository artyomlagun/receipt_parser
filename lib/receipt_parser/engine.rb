module ReceiptParser

  class << self
    mattr_accessor :kontur_ru

    self.kontur_ru = {
      url: 'https://ofd-api.kontur.ru/v1/cash-receipt/kontur/?fiscalSignature=%{fp}&fnSerialNumber=%{fn}&fiscalDocumentNumber=%{fd}'
    }

    mattr_accessor :nalog_ru

    self.nalog_ru = {
      user: '+79151595136',
      password: '314144',
      device: {
        os: "Android 4.4.4",
        version: "2",
        client_version: "1.4.1.3",
        user_agent: "okhttp/3.0.1"
      },
      url: 'https://proverkacheka.nalog.ru:9999/v1/inns/*/kkts/*/fss/%{fn}/tickets/%{fd}'
    }

    mattr_accessor :users_nalog_ru

    self.users_nalog_ru = [{ user: '+79151595136', password: '314144'}]

    mattr_accessor :nvg_ru

    self.nvg_ru = {
      url: 'https://ofd.nvg.ru//public/document?summa=%{sum}&fpd=%{fp}'
    }

    mattr_accessor :ofd_one_ru

    self.ofd_one_ru = {
      url: "https://consumer.1-ofd.ru/api/tickets/find-ticket"
    }

    mattr_accessor :platforma_ofd_ru

    self.platforma_ofd_ru = {
      url: 'https://lk.platformaofd.ru/web/noauth/cheque?fn=%{fn}&fp=%{fp}&i=%{fd}',
      xpath: {
        user: 'div.check-top div',
        products: 'div.check-section',
        item: 'div.check-product-name',
        quantity: 'div.check-col.check-col-right'
      }
    }

    mattr_accessor :taxcom_ru

    self.taxcom_ru = {
      url: 'https://receipt.taxcom.ru/v01/show?fp=%{fp}&s=%{sum}',
      xpath: {
        user: 'div.receipt_report table tr td b span',
        not_found: 'div.jumbotron.notfound h1',
        products: 'table.verticalBlock',
        item: 'td.position span',
        quantity: 'tr.result td span'
      }
    }

    mattr_accessor :receipt_e_parsers

    self.receipt_e_parsers = %w(ReceiptParser::KonturParser ReceiptParser::NvgParser ReceiptParser::PlatformaOfdParser ReceiptParser::TaxcomParser ReceiptParser::OfdOneParser ReceiptParser::NalogParser)

    mattr_accessor :default_parser

    self.default_parser = 'ReceiptParser::CompositeEReceiptParser'

  end

  def self.setup(&block)
    yield self
  end

  class Engine < ::Rails::Engine
    isolate_namespace ReceiptParser
  end
end
