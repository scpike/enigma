# encoding: utf-8

require 'test_helper'

class EndpointTest < Test::Unit::TestCase
  def setup
    ENV['ENIGMA_KEY'] = 'test_key'
    @datapath = 'us.gov.whitehouse.visitor-list'
    @ep = Enigma::Endpoint.new(@datapath)
  end

  def test_needs_datapath
    assert_raises ArgumentError do
      Enigma::Endpoint.new
    end
  end

  def test_query_params
    ep = Enigma::Endpoint.new(@datapath, limit: 100)
    assert_equal({ limit: 100 }, ep.params)
  end

  def test_has_descendants
    assert Enigma::Endpoint.descendants.include? Enigma::Meta
  end

  def test_where_clause_from_hash
    assert_equal 'firstName=Steve', @ep.serialize_where({ firstName: 'Steve' })
  end

  def test_where_clause_from_string
    assert_equal 'firstName=Steve', @ep.serialize_where('firstName=Steve')
  end

  def test_search_clause_from_hash
    search_hash = { nameFirst: 'andrew', nameLast: ['white', 'brown', 'black'] }
    assert_equal('@nameFirst (andrew) @nameLast (white|brown|black)',
                 @ep.serialize_search(search_hash))
  end

  def test_search_clause_from_string
    search = '@namefirst (andrew) @namelast (white|brown)'
    assert_equal(search, @ep.serialize_search(search))
  end

  def test_select_clause_from_string
    select = 'namefirst,namelast'
    assert_equal(select, @ep.serialize_select(select))
  end

  def test_select_clause_from_array
    select = ['namefirst', 'namelast']
    assert_equal('namefirst,namelast', @ep.serialize_select(select))
  end
end
