# Accessing the Enigma metadata and data apis

#### Create a client, key should be set in the environment variable 'ENIGMA_KEY'

    client = Enigma::Client.new

#### Let's look at internet use in the United States

    res = client.meta('us.gov.census.internet.usage11')

#### The result is a Hashie::Mash object, so you can access it like a hash or like an object

    puts res.keys

    => ["datapath", "success", "info", "result", "raw"]

`raw` is the raw repsonse from the Enigma api. Everything else is
the contents of the api response

#### Verify this is a table (something we can get data about):

    res.info.result_type

    => "table"

#### Let's see the columns

    res.result.columns.each { |c| puts "#{c.id}: #{c.description}" }

> region: State Region
>
> total_over3: Total (thousands)
>
> number_somewhere: Number of individuals accessing the Internet from some location (thousands). "Some location" means Internet access that occurs either inside or outside the householder's home.
>
> percent_somewhere: Percent of individuals accessing the Internet from some location. "Some location" means Internet access that occurs either inside or outside the householder's home.
>
> number_inhome: Individual lives in household with Internet (thousands). At least one member of the individual's household reported using the Internet from home.
>
> percent_inhome: Percent of individual living in household with Internet. At least one member of the individual's household reported using the Internet from home.
>
> serialid: Serialid

#### Now let's get the data

    data = client.data('us.gov.census.internet.usage11')

    data.result.each { |r| puts "#{r.region} #{r.percent_inhome}" }

> United States 76.50
>
> Alaska 80.00
>
> Alabama 69.50
>
> Arizona 76.00
>
> Arkansas 68.50
>
> ...

#### Let's find the state withthe highest percentage. We also only care about the region and percent_inhome columns

    res = client.data('us.gov.census.internet.usage11',
                      sort: 'percent_inhome',
                      select: [ 'region', 'percent_inhome' ])

    puts res.result.first.to_hash

    => {"region" =>"New Hampshire", "percent_inhome" =>"87.10"}

##### What about the lowest?

    puts res.result.last.to_hash

    => {"region" =>"Mississippi", "percent_inhome" =>"61.40"}

##### Let's search for Pennsylvania

    res = client.data('us.gov.census.internet.usage11',
                      select: [ 'region', 'percent_inhome' ],
                      search: { region: 'Pennsylvania })

#### Verify only one result found

    > res.info.total_results

    => 1

#### Check it out

    > puts res.first.to_hash

    => {"region" =>"Pennsylvania", "percent_inhome" =>"75.40"}
