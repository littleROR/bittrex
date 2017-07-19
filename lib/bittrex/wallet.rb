module Bittrex
  class Wallet
    attr_reader :id, :currency, :balance, :available, :pending, :address, :requested, :raw

    def initialize(attrs = {})
      @id = attrs['Uuid'].to_s
      @address = attrs['CryptoAddress']
      @currency = attrs['Currency']
      @balance = attrs['Balance']
      @available = attrs['Available']
      @pending = attrs['Pending']
      @raw = attrs
      @requested = attrs['Requested']
    end

    def self.all
      response = client.get('account/getbalances')
      if response.code >= 200 && response.code < 300
        result = JSON.parse(response.body)['result']
        
        result = result.map { |data| new(data) } if result
      end
      result || []
    end

    private

    def self.client
      @client ||= Bittrex.client
    end
  end
end
