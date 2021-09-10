#!/usr/bin/env ruby
%w(time pathname rubygems yaml).each{|r| require r}
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

schedule_file = File.open(Pathname(__dir__)+'HS_Schedule.yaml') {|yf| YAML::load(yf)}
late_starts = schedule_file['late_start_dates']
this_period = String.new()
if late_starts.include?(date) then
  schedule_type="late_start"
else
  schedule_type="normal"
end
schedule = schedule_file[schedule_type]

schedule.each{|hr|
  start_time = Time.parse(hr['start'])
  end_time = Time.parse(hr['end']) 
  time = Time.now()
  if (start_time..end_time).cover?(time)
     this_period = hr['period'].ordinal
  end
}
unless this_period.nil?
  puts this_period
end

case schedule_type
when "late_start"
  puts "Late Start"
when "normal"
  puts "Normal Schedule"
else
  puts "Unrecognized Schedule"
end

schedule.each{|hr|
  puts "#{hr['period'].ordinal}:  #{hr['start']} - #{hr['end']}"
}