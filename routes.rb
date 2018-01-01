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

        # map '/reverse' do
        #           run RunPortal::App.new
        #         end
        #         
        #         map '/lookup' do
        #           run RunPortal::Lookup.new
        #         end
        #         
        #         map '/sidekiq' do
        #           run Sidekiq::Web
        #         end
        #         
        #         map '/status' do
        #           map '/' do
        #             run RunPortal::Status.new
        #           end
        #         end
        
      end
    end
    
    def call(env)
      @app.call(env)
    end
  end
end

# map '/version' do
#   map '/' do
#     run Proc.new {|env| [200, {'Content-Type' => 'text/html'}, ['dddd']] }
#   end
# 
#   map '/last' do
#     run Proc.new {|env| [200, {'Content-Type' => 'text/html'}, ['sssss']] }
#   end
# end