class Testy
  def self.import2(values)

    # Duplicating some info here, might be a cleaner way to structure this.
    template = [
      { type: :sites, collection: :buildings },
      { type: :buildings, collection: :olts },
      { type: :olts, collection: :splitters }
    ]

    graph = { sites: [] }

    values.each do |row|
      previous = graph  # Start at the top

      row.each_with_index do |col, index|
        next if col.nil?

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

  def self.template_order(headers, values)
    order_index = 0
    fail_safe = 0

    ordered = []

    while order_index < headers.count
      values.each_with_index do |value, index|
        if headers[order_index] == value
          ordered << index
          order_index += 1
          fail_safe = 0
        end
      end

      fail_safe += 1
      return 'error' if fail_safe > 100
    end

    ordered
  end

  def self.reorder_sheet(order, values)
    ordered = []

    values.each do |row|
      ordered << order.collect { |index| row[index] }
    end

    ordered
  end

  def self.read_spreadsheet(file)
    found_headers = false
    data = []

    spreadsheet = Roo::Spreadsheet.open(file, extension: :xls)

    spreadsheet.sheet('Sheet 1').each do |row|
      # TODO: might want to check inclusion of all header values and not just if the first one matches
      found_headers = true if row[0] == "Site"

      if found_headers == true
        data << []
        row.each do |col|
          data.last << col
        end
      end
    end

    found_headers ? data : 'error'
  end

  def self.do_it(file)
    spreadsheet_data = read_spreadsheet(file)

    headers = ["Site", "Building", "OLT Rack"]

    template_order = self.template_order(headers, spreadsheet_data[0])

    self.reorder_sheet(template_order, spreadsheet_data)
  end
end
