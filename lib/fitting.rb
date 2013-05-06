class Fitting
			@loSlots
			@medSlots
			@hiSlots
			@rigs
			@subSystems
			
			@shipTypeID
			
	def loSlots
		return @loSlots
	end
	def medSlots
		return @medSlots
	end
	def hiSlots
		return @hiSlots
	end
	def rigs
		return @rigs
	end
	def subSystems
		return @subSystems
	end
	def shipTypeID
		return @shipTypeID
	end
	def initialize(rows,shipid)
	@loSlots=Array.new
			@medSlots=Array.new(8)
			@hiSlots=Array.new(8)
			@rigs=Array.new(3)
			@subSystems=Array.new(5)
		@shipTypeID=shipid
		rows.each do |row|
			@flag = row.flag
			if row.categoryID!=8 then
				if @flag>10&&@flag<19
					@loSlots[@flag-10]=row
				end
				if @flag>18&&@flag<27 then
					@medSlots[@flag-18]=row
				end
				if @flag>26&&@flag<35 then
					@hiSlots[@flag-26]=row
				end
				if @flag>91&&@flag<95 then
					@rigs[@flag-91]=row
				end
				if @flag>125&&@flag<131 then
					@subSystems[@flag-125]=row
				end
			end
		end
	end
end