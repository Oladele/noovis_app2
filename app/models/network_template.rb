class NetworkTemplate < ActiveRecord::Base
  validates :name, presence: true
end
