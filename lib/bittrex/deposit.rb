module Bittrex
  class Deposit
    attr_reader :id, :transaction_id, :address, :quantity, :currency, :confirmations, :executed_at

    def initialize(attrs = {})
      @id = attrs['Id']
      @transaction_id = attrs['TxId']
      @address = attrs['CryptoAddress']
      @quantity = attrs['Amount']
      @currency = attrs['Currency']
      @confirmations = attrs['Confirmations']
      @executed_at = Time.parse(attrs['LastUpdated'])
    end

    def self.all
      response = client.get('account/getdeposithistory')
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
