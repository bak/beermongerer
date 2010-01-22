require 'rubygems'
require 'sinatra'
require 'haml'

get '/' do
  data_file = 'data/data.json'
  @data = File.open(data_file).read.chomp if File.exists?(data_file)
  haml :form
end