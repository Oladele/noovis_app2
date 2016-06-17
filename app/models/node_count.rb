class	NodeCount
  attr_accessor :node_type, :count
  attr_reader :node_type_pretty

	def initialize(node_type, count)
		@node_type = node_type
		@count = count

		@node_type_pretty = node_type.pluralize.titleize
	end

end
