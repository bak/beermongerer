require 'rubygems'
require 'aws/s3'
require 'open-uri'
require 'hpricot'
require 'json'

task :get_data do
  puts "It is #{Time.now} ..."
  
  begin
    # make the AWS connection
    AWS::S3::Base.establish_connection!( 
      :access_key_id => 'AKIAI4EAO2ZH7KVYFG4Q', 
      :secret_access_key => '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',
      :use_ssl => true,
      :server => 'beermongerer.s3.amazonaws.com'
    )
    
    filename = 'data.json'
    
    # File must be more than 6 hours old
    if (AWS::S3::S3Object.exists?(filename) && (Time.now - AWS::S3::S3Object.find(filename).last_modified >= 21600)) || !AWS::S3::S3Object.exists?(filename)
      puts "File is stale or missing - we're going to hit the site!"
      data = [ ]
      url_base = 'http://www.thebeermongers.com/'
      alpha_index_path = 'index.cfm?fa=brewsByLetter&letter='
      ('a'..'z').each do |alpha|
        document = Hpricot(open("#{url_base}#{alpha_index_path}#{alpha}", "User-Agent" => "Beermongerer :: http://beermongerer.heroku.com"))
        elements = document/"#colTwo"/"ul"/"li"/"a"
        elements.each do |element|
          data << {:text => element.inner_html.strip.gsub(/\*$/, ' (out of stock)'), :url => (url_base + element.attributes['href'])}
        end
      end
      puts "Writing the file ..."
      AWS::S3::S3Object.store(filename,data.to_json)
      puts "... done."
    else
      puts "File is present and is not stale. Doing nothing."
    end
  rescue AWS::S3::ResponseError => e
    puts "!!! There was an error: #{e}"
  end
  
end
