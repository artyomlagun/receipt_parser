module ReceiptParser
  class NalogParser < EReceiptParser

    def initialize(params, tried_users = [], recheck = false)
      @fn = params[:fn]
      @fd = params[:i]
      @fp = params[:fp]
      @uuid = `echo uuidgen | tr -d '-'`
      @params = params
      @sleep_time = params[:sleep]
      @tried_users = tried_users
      @recheck = recheck
    end

    def parse
      super() do |response|
        LogService.log("NalogParser: #{response[:body]} #{@recheck}")
        case response[:code]
        when 200
          response_body = JSON.parse(response[:body].force_encoding('UTF-8'))
          receipt_items = response_body['document']['receipt']['items'].map do |item|
            ReceiptParser::ReceiptItem.new(item['name'], item['quantity'], item['price'])
          end
          ReceiptParser::Receipt.new(receipt_items, @fp, @fd, @fn, response_body['document']['receipt']['user'], response_body['document']['receipt']['dateTime'])
        when 402
          if @tried_users.length == ReceiptParser.users_nalog_ru[:users].length
            raise InvalidReceiptError, response[:body]
          end
          NalogParser.new(@params, @tried_users).parse
        when 202, 406
          LogService.log("NalogParser code: #{response[:code]} #{@recheck}")
          LogService.log("NalogParser body: #{response[:body]} #{@recheck}")
          sleep(@sleep_time || 4)
          NalogParser.new(@params, @tried_users, true).parse unless @recheck
        else
          raise InvalidReceiptError, response[:body]
        end
      end
    end


    protected

    def ofd_url
      URI(ReceiptParser.nalog_ru[:url] % {fn: @fn, fd: @fd})
    end

    def headers
      user = if @tried_users.present? && @recheck
        @tried_users.last
      elsif @tried_users.present?
        next_user
      else
        @tried_users << NalogUsersService.instance.next
        @tried_users.last
      end
      LogService.log("NalogParser USER: #{user}")
      {
          "Device-Id": @uuid[0..@uuid.length - 2],
          "Device-OS": ReceiptParser.nalog_ru[:device][:os],
          "Version": ReceiptParser.nalog_ru[:device][:version],
          "ClientVersion": ReceiptParser.nalog_ru[:device][:client_version],
          "User-Agent": ReceiptParser.nalog_ru[:device][:user_agent],
          "Cache-Control": "no-cache",
          basic_auth: user
      }
    end

    def payload
      {
          "fiscalSign": @fp,
          "sendToEmail": "no"
      }
    end

    def next_user
      user = @tried_users.last
      users = ReceiptParser.users_nalog_ru[:users]
      current_user_index = users.index(user)
      current_user_index += 1
      current_user_index = 0 if current_user_index == users.length
      @tried_users << users[current_user_index]
      @tried_users.last
    end
  end
end
