require 'faraday'

module ReceiptParser
  class HttpClient
    include Singleton

    HTTP_METHOD_GET = :get
    HTTP_METHOD_POST = :post

    @@mimic_methods = [HTTP_METHOD_GET, HTTP_METHOD_POST]

    def initialize
      @connection = Faraday.new(nil, {request: {timeout: 20}})
    end

    def method_missing(method_name, *args, &block)
      if @@mimic_methods.include?(method_name.to_sym)
        do_call(method_name, *args, &block)
      else
        raise ArgumentError.new("Method `#{m}` doesn't exist.")
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      @@mimic_methods.include?(method_name.to_sym) || super
    end

    private

    def do_call(http_method, url, query, headers, request_body, &block)
      begin
        if headers && headers[:basic_auth]
          @connection.basic_auth(headers[:basic_auth][:username], headers[:basic_auth][:password])
        end
        response = @connection.public_send(http_method.to_sym) do |request|
          request.url(url)
          if headers
            headers.except(:basic_auth).each {|k, v| request.headers[k] = v}
          end
          request.params = query unless query.nil?
          request.body = request_body.to_json if request_body
        end
        {code: response.status, body: response.body}
      ensure
        @connection.headers.delete('Authorization')
      end
    end
  end
end
