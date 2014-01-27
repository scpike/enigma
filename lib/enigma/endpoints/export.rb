# coding: utf-8
module Enigma
  # The export endpoint has no filtering, but it returns a URL where
  # the download will eventually be available. This client will
  # default to waiting for the file to be available before continuing
  #
  class Export < Endpoint
    attr_accessor :download, :unzip

    # The API request responds with a URL to poll until it's
    # ready. Create a new download object with that URL and return it
    #
    # @return [Download]
    #
    def request
      req = Typhoeus::Request.new(url, method: :get, params: params).run
      Enigma.logger.info req.body
      res = Response.parse(req)
      Download.new(res)
    end
  end
end
