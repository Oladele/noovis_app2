class TestNetworkGraph < ActiveRecord::Base
  belongs_to :building

  validates :graph, presence: true
end
