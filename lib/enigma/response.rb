# coding: utf-8

module Enigma
  # We'll wrap the response in a Hashie::Mash subclass so that you can
  # access the attributes as function calls
  #
  # Raw response is kept in the `raw` attribute
  #
  class Response
    def self.parse(res)
      mash = Hashie::Mash.new(JSON.parse(res.body))
      mash.raw = res
      fail mash.message.to_s if mash.info && mash.info.error
      mash
    end
  end
end
