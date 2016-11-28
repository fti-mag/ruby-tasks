class PArray
	def initialize(tn, arr)
		@tn = tn
		@arr = arr
	end

	def pmap(&block)
		s = (@arr.size - 1)/@tn + 1
		slices = (0...@tn).map{|n| @arr[n*s, s]}
		threads = slices.map{|slc| Thread.new{if slc then slc.map(&block) else [] end}}
		threads.map{|t| t.join; t.value}.inject{|mem, slc| mem + slc}
	end

	def all?(&block)
		pmap(&block).all?
	end

	def any?(&block)
		pmap(&block).any?
	end

	def map(&block)
		pmap(&block)
	end

	def select(&block)
		pmap{|e| [block.call(e), e]}.select{|a| a[0]}.map{|a| a[1]}
	end
end

arr = PArray.new(4, [1,2,3,4,8,9,0])

puts 'all?'
puts arr.all?{|e| e > -1}
puts arr.all?{|e| e > 1}
puts

puts 'any?'
puts arr.any?{|e| e < 1}
puts arr.any?{|e| e < 0}
puts

puts 'map'
puts arr.map{|e| e*e}
puts

puts 'select'
puts arr.select{|e| e % 2 == 0}
puts