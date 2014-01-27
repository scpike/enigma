# Export API

#### Start the connection

    client = Enigma::Client.new

    dl = client.export('us.gov.census.internet.usage11')

#### This did *not* download anything. The api replied with a link to where the file will eventually be

    puts dl.download_url

> Secret one time url

#### If you want the actual contents, you can ask the client to poll until the file is available

    dl.get # puts the zipped contents in dl.raw_download

#### Write the zipped contents to a file

    zipfile = File.open('out.zip', 'wb')

    dl.write zipfile

#### Write the unzipped contents to a file

    csvfile = File.open('out.csv', 'wb')

    dl.write_csv csvfile

#### Read the contents of the csv file

    dl.parse.each do |row|
       puts row.inspect
    end
