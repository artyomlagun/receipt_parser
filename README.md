# ReceiptParser
Web service for receipts validating and parsing

## Usage
Use 2 routes:

`POST` `/receipt_parser/parse` - for parsing your receipt

`POST` `/receipt_parser/search` - for searching your receipt


You should send parameters in structure like below:
```ruby
request.headers['Content-Type'] = 'application/json'
request.body = {  
  receipt_info: {
    ...
  }
}.to_json
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'receipt_parser'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install receipt_parser
```
## Configuration

Just place rb into the ```/config/initializers``` folder and configure parser like that:

```ruby
ReceiptParser.setup do |config|
    config.kontur_ru = {
        url: 'https://ofd-api.kontur.ru/v1/cash-receipt/?fiscalSignature=%{fp}&fnSerialNumber=%{fn}&fiscalDocumentNumber=%{fd}'

    }

    config.nalog_ru = {
        user: 'xxxxx',
        password: 'xxxxx',
        device: {
            os: "Android 4.4.4",
            version: "2",
            client_version: "1.4.1.3",
            user_agent: "okhttp/3.0.1"
        },
        url: 'https://proverkacheka.nalog.ru:9999/v1/inns/*/kkts/*/fss/%{fn}/tickets/%{fd}'

    }

    config.nvg_ru = {
        url: 'https://ofd.nvg.ru//public/document?summa=%{sum}&fpd=%{fp}'
    }

    config.ofd_one_ru = {
        url: "https://consumer.1-ofd.ru/api/tickets/find-ticket"

    }

    config.platforma_ofd_ru = {
        url: 'https://lk.platformaofd.ru/web/noauth/cheque?fn=%{fn}&fp=%{fp}&i=%{fd}',
        xpath: {
            products: 'div.check-section div.check-product-name'
        }
    }

    config.taxcom_ru = {
        url: 'https://receipt.taxcom.ru/v01/show?fp=%{fp}&s=%{sum}',
        xpath: {
            not_found: 'div.jumbotron.notfound h1',
            positions: 'div.receipt_report table.verticalBlock td.position span'
        }
    }

end
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
