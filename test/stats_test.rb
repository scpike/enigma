# encoding: utf-8

require 'test_helper'

class StatsTest < Test::Unit::TestCase
  def setup
    @client = Enigma::Client.new(key: TEST_KEY)
  end

  def test_simple_data_request
    VCR.use_cassette('simple_stats') do
      response = @client.stats('us.gov.whitehouse.visitor-list',
                               select: 'type_of_access')
      assert_equal 'type_of_access', response.info.column.id
    end
  end

  def test_compound_average
    VCR.use_cassette('compound_average') do
      response = @client.stats('us.gov.whitehouse.visitor-list',
                               select: 'release_date',
                               by: :avg,
                               of: :total_people)
      assert_equal(734, response.result.compound_avg.first.avg.to_i)
    end
  end
end
