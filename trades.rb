#!/usr/bin/env ruby
require "#{ ::File.expand_path( '../',  __FILE__ ) }/boot.rb"

hourly_closes = Gemini::MDB_CLIENT[:hourly_closes]
hourly_closes.indexes.create_one( { timestamp: 1 }, { unique: true, background: true })

price_hash = {}

Gemini::HOURS_BACK.downto(0) do |i|
  timeback = (Time.now.utc).end_of_hour-i.hour-Gemini::LEEWAY
  
  uri = URI( Gemini::TRADES_URL + "?timestamp=#{timeback.to_time.to_i}000&limit_trades=#{Gemini::LIMIT}" )
  puts "Calling #{timeback}: #{uri}"

  response = Net::HTTP.get(uri)
  btcusd_trades = JSON.parse(response)

  btcusd_trades.reverse.map{ |datum| 
    timestamp =  Time.at( datum["timestamp"].to_i ).utc
    price_hash[ timestamp.strftime("%Y%m%d%H") ] = { price: datum["price"].to_f, timestamp: timestamp.beginning_of_hour }
  }

end

price_hash.each do |key,value|
  doc = { price: value[:price] }
  hourly_closes.update_one( { timestamp: value[:timestamp] }, { '$set' => doc }, { upsert: true } )
end


# my_data = Indicators::Data.new( price_hash.values )
# p my_data.calc(:type => :macd, :params => [12, 26, 9])