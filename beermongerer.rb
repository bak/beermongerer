require 'rubygems'
require 'sinatra'
require 'haml'
require 'aws/s3'

get '/' do
  begin
    # make the AWS connection
    AWS::S3::Base.establish_connection!( 
      :access_key_id => '***********', 
      :secret_access_key => '***********',
      :use_ssl => true,
      :server => '***********'
    )
    
    filename = 'data.json'
    if AWS::S3::S3Object.exists?(filename)
      @data = AWS::S3::S3Object.find(filename).value.chomp
    end
  rescue Exception => e
    
  end
  
  haml :form
end
