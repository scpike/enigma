# encoding: utf-8

require 'test_helper'

class DataTest < Test::Unit::TestCase
  def setup
    @client = Enigma::Client.new(key: TEST_KEY)
  end

  def test_bad_request
    VCR.use_cassette('data_with_error') do
      assert_raises RuntimeError do
        response = @client.data('us.gov.whitehouse.salaries')
      end
    end
  end

  def test_simple_data_request
    VCR.use_cassette('simple_data') do
      response = @client.data('us.gov.whitehouse.visitor-list')
      assert_equal 500, response.info.rows_limit
      assert_equal 3427529, response.info.total_results
      assert_equal 'TED', response.result.first.namefirst
    end
  end

  def test_filter_with_search
    VCR.use_cassette('filtered_data') do
      response = @client.data('us.gov.whitehouse.visitor-list',
                              search: { namefirst: ['Steve', 'Joe'] })
      assert_equal ['JOE', 'STEVE'], response.result.map(&:namefirst).uniq.sort
    end
  end

  def test_filter_with_select
    VCR.use_cassette('selected_data') do
      response = @client.data('us.gov.whitehouse.visitor-list',
                              select: ['namefirst', 'namelast'])
      assert_equal nil, response.result.first.appt_made_date
      assert response.result.first.namefirst
    end
  end

  def test_sort
    VCR.use_cassette('sorted_data_descending') do
      response = @client.data('us.gov.whitehouse.visitor-list',
                              sort: 'namefirst-')
      names = response.result.map(&:firstname)
      assert_equal names, names.sort.reverse
    end
  end

  def test_limit
    VCR.use_cassette('limit_data') do
      response = @client.data('us.gov.whitehouse.visitor-list',
                              limit: 1)
      assert response.info.total_results > 1
      assert_equal 1, response.info.rows_limit
      assert_equal 1, response.result.count
    end
  end

  def test_page
    VCR.use_cassette('page_data') do
      response = @client.data('us.gov.whitehouse.visitor-list',
                              limit: 1, page: 2)
      assert response.info.total_results > 1
      assert_equal 1, response.info.rows_limit
      assert_equal 2, response.info.current_page
    end
  end

  def test_sort_defaults_ascending
    VCR.use_cassette('sorted_data') do
      response = @client.data('us.gov.whitehouse.visitor-list',
                              sort: 'namefirst')
      names = response.result.map(&:firstname)
      assert_equal names, names.sort
    end
  end
end
