module Gemini
  #Mongo::Logger.logger.level = Logger::FATAL
  MDB_CLIENT = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'gemini_development')
  
  TRADES_URL = "https://api.gemini.com/v1/trades/btcusd"
  HOURS_BACK = 24*7
  LEEWAY = 60.seconds
  LIMIT = 500
end