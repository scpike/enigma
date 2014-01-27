# encoding: utf-8

require 'test_helper'

class EnigmaTest < Test::Unit::TestCase
  def test_response
    res = OpenStruct.new
    res.body = "{\"datapath\": \"us.gov.whitehouse.salaries\"}"
    r = Enigma::Response.parse res
    assert_equal res, r.raw
    assert_equal 'us.gov.whitehouse.salaries', r.datapath
  end
end
