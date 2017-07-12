require 'time'

module Bittrex
  class Market
    attr_reader :name, :currency, :base, :currency_name, :base_name, :minimum_trade, :active, :created_at, :raw

    def initialize(attrs = {})
      @name = attrs['MarketName']
      @currency = attrs['MarketCurrency']
      @base = attrs['BaseCurrency']
      @currency_name = attrs['MarketCurrencyLong']
      @base_name = attrs['BaseCurrencyLong']
      @minimum_trade = attrs['MinTradeSize']
      @active = attrs['IsActive']
      @created_at = Time.parse(attrs['Created'])
      @raw = attrs
    end

    def self.all
      response = client.get('public/getmarkets')
      if response.code >= 200 && response.code < 300
        result = JSON.parse(response.body)['result'].map { |data| new(data) }
      end
      result || []
    end

    private

    def self.client
      @client ||= Bittrex.client
    end
  end
end
