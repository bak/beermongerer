require 'open-uri'
require 'rubygems'
require 'hpricot'
require 'json'

task :cron do
  puts "Building data file at #{Time.now} ..."
  data_file = File.dirname(__FILE__) + '/../../data/data.json'

  if (File.exist?(data_file) && (Time.now - File.new(data_file).mtime >= 21600)) || !File.exist?(data_file)
    File.open(data_file,'w') do |f|
      data = [ ]
    
      # we build our data file by requesting 26 different pages from beermongers' site
      url_base = 'http://www.thebeermongers.com/'
      alpha_index_path = 'index.cfm?fa=brewsByLetter&letter='
    
      ('a'..'z').each do |alpha|
        document = Hpricot(open(url_base + alpha_index_path + alpha))
        elements = document/"#colTwo"/"ul"/"li"/"a"
        elements.each do |element|
          data << {:text => element.inner_html.strip.gsub(/\*$/, ' (out of stock)'), :url => (url_base + element.attributes['href'])}
        end
      end
      f.puts data.to_json
    end
    puts "done."
  else
    puts "file was not stale."
  end
end
