class Testy
  #def self.import
    ##file = Roo::Spreadsheet.open(File.join(Rails.root, 'import_refactor_easy.xls'), extension: :xls)
    #file = Roo::Spreadsheet.open(File.join(Rails.root, 'import_refactor_xls.xls'), extension: :xls)

    #graph = {}
    #found_headers = false

    #file.sheet('Sheet 1').each do |row|
      #if found_headers
        #subgraph = {}

        #row.each do |column|

        #end
      #end

      #found_headers = true if row[0] == "site"
    #end

    #return graph
  #end

  #def self.new_import(values)
    #graph = {}

    #values.each do |row|
      #graph = save_piece({}, row)
    #end

    #graph
  #end

  #def self.save_piece(graph, values)
    #return {} if values.empty?

    #value = values[0].to_sym
    #tail = values[1..-1]

    #if graph.key?(value)
      #self.save_piece(graph, tail)
    #else
      #graph[value] = {}
      #return { value => self.save_piece(graph, tail) }
    #end
  #end

  def self.import2(values)
    graph = { sites: [] }

    # Duplicating some info here, might be a cleaner way to structure this.
    template = [
      { type: :sites, collection: :buildings },
      { type: :buildings, collection: :olts },
      { type: :olts, collection: :splitters }
    ]

    values.each do |row|
      previous = graph  # Start at the top

      row.each_with_index do |col, index|
        type = template[index][:type]
        collection = template[index][:collection]

        # Do we have this node yet?
        object = previous[type].select { |object| object[:value] == col }.first

        # If not, make it.
        if object.nil?
          object = { value: col, collection => [] }
          previous[type] << object
        end

        # Set the current place in the nested structure for the next iteration
        previous = object
      end
    end

    graph
  end
end

        #if index == 0
          #site = graph[:sites].select { |site| site[:value] == col }.first

          #if site.nil?
            #site = { value: col, buildings: [] }
            #graph[:sites] << site
          #end

          #previous = site
        #end

        #if index == 1
          #building = previous[:buildings].select { |building| building[:value] == col }.first

          #if building.nil?
            #building = { value: col, olts: [] }
            #previous[:buildings] << building
          #end

          #previous = building
        #end

        #if index == 2
          #olt = previous[:olts].select { |olt| olt[:value] == col }.first

          #if olt.nil?
            #previous[:olts] << { value: col, splitters: [] }
          #end
        #end

#site: {
  #value: 'site1',
  #buildings: [
    #{
      #value: 'building1',
      #olt1s: [

      #]
    #}
  #]
#}
