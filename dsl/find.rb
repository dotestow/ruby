require './search'
require 'net/http'

def find(from = nil, to = nil, &block)
  search = Search.new
  search.from(from) if from
  search.to(to) if to
  search.instance_eval(&block) if block_given?
  url =  search.compile # TODO
  html = Net::HTTP.get("rozklad-pkp.pl", url)
  date = get_date(html)
  puts date.join(" ")
  date
end

def get_date(html)
  require 'nokogiri'
  doc = Nokogiri::HTML(html)
  date = doc.css(".selected").first.css("td[data-value]").first["data-value"]
  [date[0..-6], date[-5..-1]]
end

find do
  from 'Libiąż'
  to 'Krakow'
  after '12:56'
  date '14.10.14'
end

find "Krynica", "Muszyna"
