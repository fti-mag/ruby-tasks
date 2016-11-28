class Message
	def initialize(date, time, host, service, text)
		@date = date
		@time = time
		@host = host
		@service = service
		@text = text
	end

	def date
		@date
	end

	def time
		@time
	end

	def host
		@host
	end

	def service
		@service
	end

	def text
		@text
	end

	def to_s
		@date + " " + @host + " " + @service + ": " + @text
	end
end

messages = []

date = {}
services = {}


def add(hash, key, val)
	if not hash[key] then
		hash[key] = []
	end
	hash[key].push(val)
end


File.readlines('kern.new.log').each do |line|
	m = /^
		(\w+)\s+                   # month
		(\d+)\s+                   # day
		(\d+:\d+:\d+)\s+           # time
		([^ ]+)\s+                 # hostname
		([^\[:]+)(?:\[\d+\])?:\s+  # service name (without [pid])
		(.*)                       # message text
		$/x.match(line)

	if not m then
		puts line
	else
		msg = Message.new(m[1] + " " + m[2], m[3], m[4], m[5], m[6])
		messages.push(msg)

		add(date, msg.date, msg)
		add(services, msg.service, msg)
	end
end

puts "date:"
date.each{|key, val| puts key + ":\t" + val.size.to_s + " entries"}
puts
puts "services:"
services.each{|key, val| puts key + ":\t" + val.size.to_s + " entries"}
# messages.map{|msg| puts msg}