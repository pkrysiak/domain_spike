#main class


class BreedManager
	def initialize
	end

	def get_data_from_db
	end

	def throw_data_into_model
	end

end


class Species
	def initialize
		@species = [] # list of specimen objects
	end

	def get_all
		return @species
	end

	def get_females
	end

	def get_alive
	end

	def get_dead
	end

	def sort_by(param)
		if param == 'id'
			#sort_by id
		elsif param == 'name'
			#sort_by name
		elsif param == 'sex'
			#sort_by sex
		elsif param == 'body_lenght'
			#sort_by body_lenght etc.
		end
	end
end

class Specimen
	def initialize(id, name, sex, multiplication, body_lenght, molt, buy_date, status, notes)
		@id = id, #int
		@name = name, #str
		@sex = sex, #bool
		@multiplication = multiplication, # array of Multiplication obj
		@body_lenght = body_lenght, #int
		@molt = molt, # Array of Molt obj
		@buy_date = buy_date, # Date obj
		@status = status # bool
		@notes = notes # array of Note obj
	end

	def set_dead
		@status = false
	end

	def get_status
		@status
	end

	def get_id
		@id
	end

class Multiplication
	def initialize(copluations, cocoon, n1, n2, n3, l1, comment)
		@copluations = copluations # array of Copulation objects
		@cocoon = cocoon # Cocoon object
		@n1 = n1,
		@n2 = n2,
		@n3 = n3,
		@l1 = l1
		@comment = comment
	end

class Copulation
	def initialize(date)
		@date = date 
	end

class Cocoon
	def initialize(date, spiders)
		@date = date,
		@spiders = spiders
	end

class Molt
	def initialize(date, specimen_size)
		@date = date
		@specimen_size = specimen_size
	end

class Note
	def inititalize(title, content, date)
		@title = title
		@content = content
		@date = date
	end
