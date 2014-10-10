def find(from = nil, to = nil, &block)
  search = Search.new
  search.from(from) if from
  search.to(to) if to
  search.instance_eval(&block) if block_given?
  puts search.compile
#   TODO
#   make_request
#   parse_request
#   return result
end

find do
  from 'Libiąż'
  to 'Krakow'
  after '10:45'
  date '12.10.14'
  with_bike
end

