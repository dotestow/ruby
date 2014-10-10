require './params'

class Search
  def initialize
    @params = DEFAULT_PARAMS
    set_date(Time.now).strftime("%H:%M")
    set_time(Time.now).strftime("%d.%m.%y")
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

  def with_bike
    @params["bikeEverywhere"] = "1"
    self
  end

  def after(time)
    set_time(time)
    self
  end

  def date(date)
    set_date(date)
    self
  end

  private
  
  def set_date(date)
    @params["date"] = @params["dateStart"] = @params["dateEnd"] = @params["REQ0JourneyDate"] = date
  end
  
  def set_time(time)
    @params["time"] = @params["REQ0JourneyTime"] = time
  end
  
  def find_station(name)
    # TODO
    5100028
  end

  def compile
    prefix = "http://rozklad-pkp.pl/pl/tp?"
    params = @params.map { |k, v| "#{k}=#{v}" }.join("&")
    "#{prefix}#{params}#focus"
  end
end
