class Company < ActiveRecord::Base

	### Validations
  validates :name, uniqueness: true, presence: true

end
