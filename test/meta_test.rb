# encoding: utf-8

require 'test_helper'

class MetaTest < Test::Unit::TestCase
  def setup
    @client = Enigma::Client.new(key: TEST_KEY)
  end

  def test_simple_metadata
    VCR.use_cassette('simple_metadata') do
      response = @client.meta('us.gov.whitehouse.salaries')
      assert_equal 'us.gov.whitehouse.salaries', response.datapath
    end
  end

  def test_adds_limit_filter
    stub_request(:get, /.*meta.*limit=100.*/).to_return(body: '{}')
    @client.meta('us.gov.whitehouse.salaries', limit: 100)
  end

  def test_adds_two_filters
    stub_request(:get, /.*meta.*limit=100.*page=1.*/).to_return(body: '{}')
    @client.meta('us.gov.whitehouse.salaries', limit: 100, page: 1)
  end
end
