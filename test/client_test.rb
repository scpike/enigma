# encoding: utf-8

require 'test_helper'

class EnigmaTest < Test::Unit::TestCase
  def setup
    ENV['ENIGMA_KEY'] = nil
  end

  def test_initialize_handle
    Enigma::Client.new(key: 'test')
    assert_equal 'test', Enigma.key
  end

  def test_initialize_key_from_env
    ENV['ENIGMA_KEY'] = 'test'
    Enigma::Client.new
    assert_equal 'test', Enigma.key
  end

  def test_prefers_key_from_env
    ENV['ENIGMA_KEY'] = 'env_key'
    Enigma::Client.new(key: 'bogus')
    assert_equal 'env_key', Enigma.key
  end

  def test_requires_key
    assert_raises ArgumentError do
      Enigma::Client.new
    end
  end
end
