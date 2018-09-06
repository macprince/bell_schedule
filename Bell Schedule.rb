#!/usr/bin/env ruby
%w(time rubygems yaml).each{|r| require r}
date = Date.today()
class Integer
	def ordinal
		cardinal = self.abs
		digit = cardinal%10
		if (1..3).include?(digit) and not (11..13).include?(cardinal%100) 
			self.to_s << %w{st nd rd}[digit-1]
		else
			self.to_s << 'th'
		end
	end
end

schedule_file = File.open(File.expand_path(File.dirname($0)+'/Schedule.yaml')) {|yf| YAML::load(yf)}
late_starts = schedule_file['late_start_dates']
this_period = String.new()
if late_starts.include?(date) then
  schedule = schedule_file['late_start']
else
  schedule = schedule_file['normal']
end

schedule.each{|hr|
  start_time = Time.parse(hr['start'])
  end_time = Time.parse(hr['end']) 
  time = Time.now()
  if (start_time..end_time).cover?(time)
     this_period = hr['period'].ordinal+" Period"
  end
}
unless this_period.nil?
  puts this_period
end

schedule.each{|hr|
  puts "#{hr['period'].ordinal}:  #{hr['start']} - #{hr['end']}"
}