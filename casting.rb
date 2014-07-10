module Casting
	class Person
		attr_reader :name, :gender, :age
		def initialize(params={} )
			raise 'Gender must be man or woman' unless ['man','woman'].include?(params[:gender])
			@name = params[:name]
			@gender = params[:gender]
			@age = params[:age]
		end	
	end
		
	class Role < Person
		def initialize(**params)
			raise 'age for the role must be specified in the form (30..35) for example' unless params[:age].class == Range
			super
		end	

	end	

	class Candidate < Person
		attr_reader :appearance_array

		def initialize(*arg)
			@appearance_array=[]
			super
		end	

		def acts(params={})
			raise 'Candidate may only 1 attempt on the role' if self.appearance_array.map {|el| el.role}.include?(params[:role])
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
		attr_accessor :candidate, :role, :topic, :text, :duration, :score_array
		attr_reader :score_avr

		def initialize(candidate, role, topic, text, duration)
			raise 'The age of the candidate must is under the age limit of the role' unless role.age.to_a.include?(candidate.age)
			raise 'The gender of the actor and the role must be the same' unless role.gender.eql?(candidate.gender)
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
