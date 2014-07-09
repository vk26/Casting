#module Casting
	class Person
		attr_accessor :name, :gender
		def initialize(name, gender)
			@name = name
			@gender = gender
		end	
	end
		
	class Role < Person

	end	

	class Candidate < Person
		attr_accessor :age
		attr_reader :appearance_array

		def initialize(*arg)
			@appearance_array=[]
			super
		end	

		def acts(role, topic, text, duration)
			appearance = Appearance.new(self, role, topic, text, duration)
			@appearance_array << appearance
			appearance
		end	

		def duration_sum
			@appearance_array.inject(0) { |sum, el| sum + el.duration } 
		end	

		def suitable_role
			appearance_array.max_by{ |el| el.score_avr}.role.name
		end

	end

	class Appearance	
		attr_accessor :candidate, :role, :topic, :text, :duration
		attr_accessor :score_array
		attr_reader :score_avr

		def initialize(candidate, role, topic, text, duration)
			@candidate = candidate
			@role = role
			@topic = topic
			@text = text
			@duration = duration
			@score_array = []
		end

		def score_array=(score)
			@score_array << score
		end

		def score_avr
			(@score_array.inject(0) { |sum, el| sum + el } / @score_array.size.to_f).round(2) #округляем до 2-х знаков после запятой
		end

	end

	class Jury < Person
		def evaluate(score)
			raise 'The score should be not more than 10' if score > 10
			score
			
		end

	end

#end	
