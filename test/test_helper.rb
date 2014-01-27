# encoding: utf-8
$VERBOSE = nil
$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"

require 'simplecov'
require 'rubygems'

SimpleCov.start do
  add_filter '/test/'
end

require 'test/unit'
require 'mocha/setup'
require 'webmock/test_unit'
require 'vcr'
require 'enigma'

Enigma.logger.level = Logger::WARN

VCR.configure do |c|
  c.cassette_library_dir = 'test/fixtures/vcr_cassettes'
  c.hook_into :webmock
end

# If you want to add tests that involve actual requests to the API:
#
#  1. Switch this to your api key
#
#  2. Write the tests wrapped in VCR blocks (see test/data_test.rb)
#     for some examples
#
#  3. Go into the generated cassette yml files and replace your key
#     with test-key
#
#  4. Switch thid back
#
TEST_KEY = 'test-key'
