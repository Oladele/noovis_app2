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
      # OLA for first row previous = graph = { sites: [] }

      row.each_with_index do |col, index|
        # OLA: don't think we can assume that the row's column's index matches the template's index
        # Illustrative eg: First iteration of this loop. Let's say first column in row is "olt"  for whatever reason 
        # (remember order of sheet columns DON'T match template/network hierachy)
        # then for the first iteration in this loop, below would evaluate to:
        # type = template[0][:type] which would return :sites
        # But I *think* in my illustrative example we would want type = :olts
        
        # I think above is a problem but sticking with scenario where first column *is* "site"...
        # OLA for first column of first row:
        # type = template[0][:type] = :sites
        
        # OLA for second column of first row:
        # type = template[1][:type] = :buildings
        type = template[index][:type]
        
        collection = template[index][:collection]

        # Do we have this node yet?
        object = previous[type].select { |object| object[:value] == col }.first # shouldn't be ".last" ?
        # OLA: thinking you are looking for the last node created of the current type
        # In that case should'nt we be looking for ".last" ?

        # If not, make it.
        if object.nil?
          object = { value: col, collection => [] }
          # OLA for first column of first row: 
          # object = { value: "site1", collection => [] }
          # previous = graph = { sites: [] }
          
          # OLA for second column of first row: 
          # object = { value: "building1", collection => [] }
          # previous = { value: "site1", collection: [] } ...from first column of first row. See line 106 thru 108
          previous[type] << object
          # OLA for first column of first row
          # previous = { sites: [object] }
          # graph = { sites: [object] }
          
          # OLA for second column of first row
          # previous[:buildings] << object *** expect ERROR: undefined method `<<' for nil:NilClass. See line 94 ***
          # graph = { sites: [object] }
        end

        # Set the current place in the nested structure for the next iteration
        previous = object
        # OLA for first column of first row:
        # previous = object = { value: "site1", collection: [] }
        # graph = { sites: [object] }
        
        # OLA for second column of first row:
        # previous = object = { value: "building1", collection: [] } ***I don't think it gets this far because line 101***
        # graph = { sites: [object] }
      end
      
    # OLA for first row:
    # graph = ?
    # based on ine 107 and 111, looks to me like graph does not change from...
    # graph = { sites: [object] }  ***I DON'T GET THIS***
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
