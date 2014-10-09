require 'mp3info'
require 'active_support/inflector'

# increase total_time by the length of mp3
def add_mp3_duration(total_time, mp3_path)
  begin
    total_time += Mp3Info.open(mp3_path).length
  rescue Mp3InfoError, Encoding::InvalidByteSequenceError
    puts "### Can't process #{mp3_path}"
  end
  total_time
end

# sum duration of mp3 files in the given directory recursively
def sum_time(dirname)
  total_time = 0
  Dir.entries(dirname).each do |entry|
    full_path = "#{dirname}/#{entry}"
    if entry != '.' and entry != '..' and File.directory?(full_path)
      total_time += sum_time(full_path)
    elsif entry =~ /.+\.mp3$/i
      total_time = add_mp3_duration(total_time, full_path)
    end
  end
  return total_time
end

# convert given duration in seconds into a human readable string
def time_to_s(seconds)
  time_units = [:week, :day, :hour, :minute]

  time_unit_durations = {
    minute: 60,
    hour:   3600,
    day:    3600 * 24,
    week:   3600 * 24 * 7
  }

  duration = {}
  result = ''

  time_units.each do |unit|
    if seconds >= time_unit_durations[unit]
      duration[unit] = (seconds/time_unit_durations[unit]).to_i
      seconds -= duration[unit] * time_unit_durations[unit]
    end
  end

  result += "#{duration[:week]} #{'week'.pluralize(duration[:week])}, " if duration[:week]
  result += "#{duration[:day]} #{'day'.pluralize(duration[:day])}, " if duration[:day]
  result += "#{duration[:hour]}:#{duration[:minute]}:#{seconds}"
end

total_time = 0
ARGV.each do |dir|
  total_time += sum_time(dir)
end

total_time = sum_time('.') if ARGV.empty?

puts "\nTotal mp3 files duration: #{time_to_s(total_time)}"
