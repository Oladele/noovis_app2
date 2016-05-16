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

  def self.template_order(values)
    order = ["Site", "Building", "OLT Rack"]  # This is the "network template"
    order_index = 0
    fail_safe = 0

    ordered = []

    while order_index < order.count
      values.each_with_index do |value, index|
        if order[order_index] == value
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
    headers = ["Site", "OLT Rack", "Building"]
    found_headers = false
    data = []

    spreadsheet = Roo::Spreadsheet.open(file, extension: :xls)

    spreadsheet.sheet('Sheet 1').each do |row|
      found_headers = true if row == headers

      if found_headers == true
        data << []
        row.each do |col|
          data.last << col
        end
      end
    end

    data
  end
end
