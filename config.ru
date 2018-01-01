require "#{ ::File.expand_path( '../',  __FILE__ ) }/boot.rb"

#start the app
run Gemini::Routes.new