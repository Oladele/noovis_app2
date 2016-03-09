class NetworkTemplate < ActiveRecord::Base
  has_many :network_graphs

  validates :name, presence: true
end
