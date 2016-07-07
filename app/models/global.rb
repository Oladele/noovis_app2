class Global
  include ActiveModel::Model

  attr_reader :id

  def initialize
    @id = SecureRandom.uuid
  end

  def self.network_graphs
    Company.all.collect { |company| company.network_graphs }.compact.flatten
  end
end
