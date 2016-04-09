class Global
  include ActiveModel::Model

  attr_reader :id

  def initialize
    @id = SecureRandom.uuid
  end
end
