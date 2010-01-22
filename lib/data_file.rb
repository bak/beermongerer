require 'open-uri'
require 'rubygems'
require 'hpricot'
require 'json'

class DataFile
  def build
    url_base = 'http://www.thebeermongers.com/'
    alpha_index_path = 'index.cfm?fa=brewsByLetter&letter='

    File.open('../data/data.json','w') do |f|
      data = [ ]
      ('a'..'z').each do |alpha|
        document = Hpricot(open(url_base + alpha_index_path + alpha))
        elements = document/"#colTwo"/"ul"/"li"/"a"
        elements.each do |element|
          data << {:text => element.inner_html, :url => (url_base + element.attributes['href'])}
        end
      end
      f.puts data.to_json
    end
  end
end