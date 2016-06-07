class	NodeStats
	def initialize(nodes)
		@nodes = nodes
	end

	def node_counts(node_types)
		# hash to store/lookup counts
		node_type_counts = {}

		# set hash keys(node_type) and values(count) to zero
		node_types.each do |node_type|
			node_type_counts[node_type] = 0
		end

		# count each node by node_type
		@nodes.each do |node|
			node_types.each do |node_type|
				if node[:node_type] == node_type
					node_type_counts[node_type] +=1
				end
			end
		end

		# return counts
		node_counts = node_types.map do |node_type|
			NodeCount.new node_type, node_type_counts[node_type]
		end

	end
end
