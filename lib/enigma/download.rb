# coding: utf-8

module Enigma
  # Handle polling the url returned by the Export api until we're able
  # to download it. Will load the zipped contents of the file into
  # memory, and can then either write it to disk (`write`), write the
  # unzipped version to disk (`write_csv`) or parse the unzipped
  # contents using the CSV library as an array of hashes
  #
  class Download
    DELAY = 1 # How long to wait between polling attempts, in seconds
    attr_accessor :response, :raw_download, :download_contents

    def initialize(res)
      self.response = res
    end

    # This url is where the file will eventually be available. Returns
    # a 404 until then
    #
    def download_url
      response.export_url
    end

    def datapath
      response.datapath
    end

    # Actually goes and fetches the download. Don't return the
    # raw_download because it's a massive amount of data that will
    # take over your terminal in IRB mode.
    #
    # @return true on success
    #
    def get
      @raw_download ||= do_download
      true
    end

    def write(io)
      get
      io.write raw_download
    end

    def write_tmp
      tmp = Tempfile.new(datapath)
      write(tmp)
      tmp.rewind
      tmp
    end

    def unzip_zip
      tmp = write_tmp
      Zip::File.open(tmp.path) do |zipfile|
        zipfile.first.get_input_stream.read
      end
    end

    def unzip_gz
      tmp = write_tmp
      Zlib::GzipReader.open(tmp.path) do |zipfile|
        zipfile.read
      end
    end

    # Handle either .zip or .gz responses since they've changed the
    # format.
    def unzip
      @download_contents ||=
        begin
          if download_url =~ /\.gz/
            unzip_gz
          else
            unzip_zip
          end
        end
    end

    def write_csv(io)
      unzip
      io.write download_contents
    end

    def parse(opts = {})
      opts = { headers: true, header_converters: :symbol }
      CSV.parse(unzip, opts.merge(opts || {}))
    end

    def do_download
      Enigma.logger.info "Trying to download #{download_url}"
      success = false
      until success
        req = Typhoeus::Request.new(download_url)
        req.on_complete do |response|
          if response.response_code == 404
            sleep DELAY
          else
            success = true
            return response.body
          end
        end
        req.run
      end
    end
  end
end
