require 'time'

module Bittrex
  class History
    attr_reader :id, :timestamp, :quantity, :price, :total, :filltype, :ordertype, :raw

    def initialize(attrs = {})
      attrs.each do |k, v|
        instance_variable_set("@#{k.downcase}", v)
      end
      @timestamp = Time.parse(@timestamp)
      @raw = attrs
    end

    def self.market(code)
      response = client.get("public/getmarkethistory?market=#{code}")
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
