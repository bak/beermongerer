require 'rubygems'
require 'sinatra'
require 'haml'
require 'aws/s3'
require 'tzinfo'
require 'config/s3config.rb'

set :haml, { :format => :html5 }

$tz = TZInfo::Timezone.get('America/Los_Angeles')

get '/' do
  begin
    # make the AWS connection
    AWS::S3::Base.establish_connection!( 
      :access_key_id => S3_CONFIG[:access_key_id], 
      :secret_access_key => S3_CONFIG[:secret_access_key],
      :use_ssl => true,
      :server => S3_CONFIG[:server]
    )
    
    filename = 'data.json'
    if AWS::S3::S3Object.exists?(filename)
      data_s3_object = AWS::S3::S3Object.find(filename)
      @data = data_s3_object.value.chomp
      @last_modified = $tz.utc_to_local(data_s3_object.last_modified.utc)
    end
  rescue Exception => e
    
  end
  
  haml :form
end
