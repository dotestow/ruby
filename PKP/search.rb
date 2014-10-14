class Search
  @@stations =
    File.read("ibnr").split("\n").map do |station|
      station = station.split("     ")
      [station[1].downcase, station[0]]
    end.to_h
  
  def initialize
    @params = {
      "queryPageDisplayed"=>"yes", "REQ0JourneyStopsS0A"=>"1", "REQ0JourneyStopsS0G"=>"5100028",
      "REQ0JourneyStopsS0ID"=>nil, "REQ0JourneyStops1.0G"=>nil, "REQ0JourneyStopover1"=>nil,
      "REQ0JourneyStops2.0G"=>nil, "REQ0JourneyStopover2"=>nil, "REQ0JourneyStopsZ0A"=>"1",
      "REQ0JourneyStopsZ0G"=>"5100028", "start"=>"start", "existUnsharpSearch"=>"yes", "came_from_form"=>"1"
    }
  end

  def from(station)
    nr = find_station(station)
    @params["REQ0JourneyStopsS0G"] = nr
    self
  end

  def to(station)
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
    if @params["REQ0JourneyStopsZ0G"] == @params["REQ0JourneyStopsS0G"]
      raise "Initial and target stations are the same"
    end
    params = @params.map { |k, v| "#{k}=#{v}" }.join("&")
    ["rozklad-pkp.pl", "/pl/tp?#{params}#focus"]
  end

  private
  
  def find_station(name)
    pl_to_ascii = {"ż"=>"z", "ó"=>"o", "ł"=>"l", "ć"=>"c", "ę"=>"e", "ś"=>"s", "ą"=>"a", "ź"=>"z", "ń"=>"n"}
    normalized_name = name.gsub(/[żółćęśąźń]/, pl_to_ascii).downcase
    @@stations[normalized_name] or raise "Station doesn't exist"
  end
end
