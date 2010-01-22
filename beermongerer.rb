require 'rubygems'
require 'sinatra'
require 'haml'

$: << File.join(File.dirname(__FILE__), 'lib')
require 'beermongerer/models'

get '/' do
  data_file = 'data/data.json'
  @data = File.open(data_file).read.chomp if File.exists?(data_file)
  haml :form
end
