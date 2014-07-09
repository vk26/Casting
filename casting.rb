module Casting
	class Person
		attr_accessor :name, :gender, :age
		def initialize(params={} )
			@name = params[:name]
			@gender = params[:gender]
			@age = params[:age]
		end	
	end
		
	class Role < Person
		attr_accessor :age_limit

	end	

	class Candidate < Person
		attr_accessor :age
		attr_reader :appearance_array

		def initialize(*arg)
			@appearance_array=[]
			super
		end	

		def acts(params={})
			appearance = Appearance.new(self, params[:role], params[:topic], params[:text], params[:duration])
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
		def evaluate(appearance, score)
			raise 'The score should be not more than 10' if score > 10
			raise 'Women will not put more than 7 points for the speech, which contains less than 30 words' if score > 7 && self.gender == 'woman' && appearance.text.size < 30
			raise 'Men will not put less than 7 points girls 18-25 years' if score < 7 && self.gender == 'man' && appearance.candidate.gender == 'woman' && appearance.candidate.age >= 18 && appearance.candidate.age <= 25
			
			appearance.score_array = score
			
		end

	end

end	
