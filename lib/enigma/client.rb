# coding: utf-8

module Enigma
  # Connects to the Enigma api at https://app.enigma.io/api.
  #
  class Client
    # Creates a new client connection
    #
    # @option opts [String] key - Enigma API key.
    #
    # The api key Defaults to the ENIGMA_KEY environment variable
    #
    def initialize(opts = {})
      Enigma.key = ENV['ENIGMA_KEY'] || opts[:key]
      fail ArgumentError, 'API key is required' unless Enigma.key
    end

    # Each endpoint becomes a method like `client.meta`
    #
    Endpoint.descendants.each do |klass|
      define_method klass.url_chunk do |*args|
        klass.new(*args).request
      end
    end
  end
end
