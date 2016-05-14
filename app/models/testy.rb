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

    headers = %w[site building olt]

    values.each do |row|
      previous_site = nil
      previous_building = nil

      row.each_with_index do |col, index|
        if index == 0
          site = graph[:sites].select { |site| site[:value] == col }.first

          if site.nil?
            site = { value: col, buildings: [] }
            graph[:sites] << site
          end

          previous_site = site
        end

        if index == 1
          building = previous_site[:buildings].select { |building| building[:value] == col }.first

          if building.nil?
            building = { value: col, olts: [] }
            previous_site[:buildings] << building
          end

          previous_building = building
        end

        if index == 2
          olt = previous_building[:olts].select { |olt| olt[:value] == col }.first

          if olt.nil?
            previous_building[:olts] << { value: col, splitters: [] }
          end
        end
      end
    end

    graph
  end
end

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
