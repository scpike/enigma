# Ruby client for the enigma api

Ruby client for the enigma api located at https://app.enigma.io/api. Supports ruby >= 1.9.3

Note that you need api key to use their api.

[![Build Status](https://travis-ci.org/scpike/enigma.png?branch=master)](https://travis-ci.org/scpike/enigma)

## Installation

Add this line to your application's Gemfile:

    gem 'enigma'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install enigma

## Usage

Basic usage is straightforward. There are also more detailed [data api examples](examples/data.md) and [export api examples](examples/export.md) available.

    # Defaults to looking for key in ENV['ENIGMA_KEY']

    client = Enigma::Client.new(key: :secret_key)

    client.meta('us.gov.whitehouse.visitor-list')

    res = client.data('us.gov.whitehouse.visitor-list')

    # get some data

    res.result.map { |r| ... }

    client.stats('us.gov.whitehouse.visitor-list', select: 'type_of_access')

    client.export('us.gov.whitehouse.visitor-list').parse.each do |row|
       puts row.inspect
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

### Notes

You'll need to have rubocop installed.

    gem install rubocop

Tests are run with `rake`. Check the test coverage (printed when you
run rake) as well as the output of rubocop (also run with rake).

## License

MIT license
