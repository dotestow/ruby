require './params'

class Search
  @@stations =
    File.read("ibnr").split("\n").map do |station|
      station = station.split("     ")
      [station[1].downcase, station[0]]
    end.to_h
  
  def initialize
    @params = DEFAULT_PARAMS.clone
    @from_or_to = false   # TODO check if equal instead Kraków default both
  end

  def from(station)
    @from_or_to = true
    nr = find_station(station)
    @params["REQ0JourneyStopsS0G"] = nr
    self
  end

  def to(station)
    @from_or_to = true
    nr = find_station(station)
    @params["REQ0JourneyStopsZ0G"] = nr
    self
  end

  def after(time)
    @params["time"] = @params["REQ0JourneyTime"] = time
    self
  end

  def date(date)
    param_names = ["date", "dateStart", "dateEnd", "REQ0JourneyDate"]
    param_names.each { |name| @params[name] = date }
    self
  end
  
  def compile
    prefix = "/pl/tp?"#"http://rozklad-pkp.pl/pl/tp?"
    params = @params.map { |k, v| "#{k}=#{v}" }.join("&")
    "#{prefix}#{params}#focus"
  end

  private
  
  def find_station(name)
    pl_to_ascii = {"ż"=>"z", "ó"=>"o", "ł"=>"l", "ć"=>"c", "ę"=>"e", "ś"=>"s", "ą"=>"a", "ź"=>"z", "ń"=>"n"}
    normalized_name = name.gsub(/[żółćęśąźń]/, pl_to_ascii).downcase
    @@stations[normalized_name] or raise "Station doesn't exist"
  end
end
