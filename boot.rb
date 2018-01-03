require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

ENV["RACK_ENV" ] ||= "development"

['../config/', '../lib' ].each do |dir| 
  p dir
  Dir[ "#{ ::File.expand_path( dir,  __FILE__) }/**/*.rb" ].each{ |file| p file; require file }
end