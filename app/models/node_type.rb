class NodeType < ActiveRecord::Base
  has_many :nodes

  validates :name, presence: true
  validates :name, uniqueness: true
end
