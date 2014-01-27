# encoding: utf-8
require 'test_helper'

class ExportTest < Test::Unit::TestCase
  def setup
    @client = Enigma::Client.new(key: TEST_KEY)
    Enigma::Download.any_instance.stubs(:sleep)

    # These are identical, just one is zipped
    @zipped = File.read 'test/fixtures/download.zip'
    @unzipped = File.read 'test/fixtures/download.csv'

    # www.example.com is the URL in the response to the export
    # cassette
    stub_request(:get, 'www.example.com').to_return do
      if @tried
        { body: @zipped }
      else
        @tried = true
        { status: 404 }
      end
    end
  end

  def test_export_no_dl
    VCR.use_cassette('export') do
      dl = @client.export('us.gov.whitehouse.visitor-list')
      assert dl.response.export_url
    end
  end

  def test_export_with_dl
    VCR.use_cassette('export') do
      dl = @client.export('us.gov.whitehouse.visitor-list')
      dl.get
      assert_equal @zipped, dl.raw_download
    end
  end

  def test_writing_zip
    VCR.use_cassette('export') do
      dl = @client.export('us.gov.whitehouse.visitor-list')
      dl.get
      testIO = StringIO.new
      dl.write(testIO)
      assert_equal @zipped, testIO.string
    end
  end

  def test_writing_csv
    VCR.use_cassette('export') do
      dl = @client.export('us.gov.whitehouse.visitor-list')
      dl.get
      testIO = StringIO.new
      dl.write_csv(testIO)
      assert_equal @unzipped, testIO.string
    end
  end

  def test_parse_as_csv
    VCR.use_cassette('export') do
      dl = @client.export('us.gov.whitehouse.visitor-list')
      parsed = dl.parse
      assert_equal 'Steve', parsed.first[:name]
    end
  end
end
