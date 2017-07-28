module Bittrex
  class Quote
    attr_reader :market, :bid, :ask, :last, :raw

    def initialize(market, attrs = {})
      @market = market
      @bid = attrs['Bid']
      @ask = attrs['Ask']
      @last = attrs['Last']
      @raw = attrs
    end

    # Example:
    # Bittrex::Quote.current('BTC-HPY')
    def self.current(market)
      response = client.get('public/getticker', market: market)
      if response.code >= 200 && response.code < 300
        result = new(market, JSON.parse(response.body)['result'])
      end
      result || []
    end

    private

    def self.client
      @client ||= Bittrex.client
    end
  end
end
