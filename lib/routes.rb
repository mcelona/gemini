module Gemini
  class Routes
    def initialize
      docs = { project: "Gemini",
               usage: [
                "/"
               ]
             }
      
      @app = Rack::Builder.new do
        # map '/assets' do
        #           sprockets = Sprockets::Environment.new
        #           
        #           sprockets.append_path ::File.expand_path( "../assets/javascripts", __FILE__ )
        #           sprockets.append_path ::File.expand_path( "../assets/stylesheets", __FILE__ )
        #           sprockets.append_path ::File.expand_path( "../assets/images", __FILE__ )
        #           
        #           run sprockets
        #         end
        
        map '/' do
          run Proc.new {|env| [200, {'Content-Type' => 'text/html'}, [docs.to_json] ] }
        end

        map '/prices' do
          hourly_closes = Gemini::MDB_CLIENT[:hourly_closes]
          closes = hourly_closes.find( {}, { projection: { _id: 0 }, limit: 72 } ).sort( {"timestamp": -1} )
          
          macd = Indicators::Data.new( closes.map{ |close| close[:price] }.reverse ).calc(:type => :macd, :params => [12, 26, 9])
          
          template_file = File.join( ::File.expand_path( "../", __FILE__ ), "../index.erb" )
          template = Tilt['erb'].new( template_file )
          
          #erb :index
          run Proc.new {|env| [200, {'Content-Type' => 'text/html'}, [ template.render( self, { :closes => closes.to_json, 
                                                                                                :macd => macd.to_json } ) ] ] }
        end
        #         
        #map '/lookup' do
        #  run RunPortal::Lookup.new
        #end
      end
    end
    
    def call(env)
      @app.call(env)
    end
  end
end