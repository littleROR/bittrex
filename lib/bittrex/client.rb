require 'rest-client'
require 'base64'
require 'json'

module Bittrex
  class Client
    HOST = 'https://bittrex.com/api/v1.1'

    attr_reader :key, :secret

    def initialize(attrs = {})
      @key    = attrs[:key]
      @secret = attrs[:secret]
    end

    def get(path, params = {}, headers = {})
      nonce = Time.now.to_i
      url = "#{HOST}/#{path}"
      payload = {}
      payload[:params] = params
      if key
        payload[:params][:apikey] = key
        payload[:params][:nonce]  = nonce
        payload[:headers][:apisign] = signature(url, nonce)
      end
      payload[:params].merge(headers)
      RestClient.get(url, payload)
    end

    private

    def signature(url, nonce)
      OpenSSL::HMAC.hexdigest('sha512', secret, "#{url}?apikey=#{key}&nonce=#{nonce}")
    end
  end
end
