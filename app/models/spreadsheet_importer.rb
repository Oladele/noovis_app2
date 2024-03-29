class SpreadsheetImporter
  NETWORK_TEMPLATE = ["Site", "OLT Chassis", "PON Card", "PON Port", "Building", "FDH", "Splitter", "RDT", "Room Number", "ONT SN#", "ONT GE Port 1 MAC", "ONT GE Port 2 MAC", "ONT GE Port 3 MAC", "ONT GE Port 4 MAC"].freeze

  def self.import_from_cable_runs(network_template, cable_runs)
    # Read the cable runs into a data structure we can work with.
    sheet_data = read_cable_runs(network_template, cable_runs)

    result = self.template_order(network_template, sheet_data[0])

    return result if result[:success] == false

    # Collect the sheet data in the proper order
    spreadsheet_order = result[:spreadsheet_order]
    ordered_sheet_data = self.reorder_sheet(spreadsheet_order, sheet_data)

    # Generate the structure and then build it using the network template
    structure = self.structure_for_network_template(network_template)

    data = self.build_structure(structure, ordered_sheet_data[1..-1], cable_runs.pluck(:id))  # [1..-1] is all rows but the first header row

    return data
  end

  private
    def self.read_cable_runs(network_template, cable_runs)
      result = [network_template]

      cable_runs.each_with_object([network_template]) do |cable_run, array|
        row = []

        network_template.each do |value|
          row << cable_run.send(format(value, false))
        end

        result << row
      end

      result
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
        return { success: false, message: 'Error: spreadsheet header values did not match template.', spreadsheet_order: nil } if fail_safe > 100
      end

      { success: true, message: nil, spreadsheet_order: ordered }
    end

    def self.reorder_sheet(order, values)
      values.each_with_object([]) do |row, array|
        array << order.collect { |index| row[index] }
      end
    end

    def self.structure_for_network_template(network_template)
      # Duplicating some info here, might be a cleaner way to structure this.
      network_template.each_with_object([]).with_index do |(value, array), index|
        collection_name = network_template[index + 1] # Look ahead to grab the collection name

        object = { type: self.format(value) }
        object[:collection] = self.format(collection_name) if collection_name.present?

        array << object
      end
    end

    def self.build_structure(template, values, cable_run_ids)
      graph = { sites: [] }

      values.each_with_index do |row, row_index|
        previous = graph  # Start at the top

        row.each_with_index do |col, index|
          col = "N/A" if col.nil?

          type = template[index][:type]
          collection = template[index][:collection]

          # If it's a number, `1` is sometimes read in as `1.0`
          col = is_a_float?(col) ? col.to_i.to_s : col

          # Do we have this node yet?
          object = previous[type].select { |object| object[:value] == col }.first

          # If not, make it.
          if object.nil?
            object = { value: col, cable_run_id: cable_run_ids[row_index] }
            object[collection] = [] if collection.present?  # Could be end of graph

            previous[type] << object
          end

          # Set the current place in the nested structure for the next iteration
          previous = object
        end
      end

      graph
    end


    def self.format(value, pluralize = true)
      value = value.downcase

      value =
        case value
        when "room number"
          "room"
        when "ont sn#"
          "ont sn"
        when "ont ge port 1 mac"
          "ont ge 1 mac"
        when "ont ge port 2 mac"
          "ont ge 2 mac"
        when "ont ge port 3 mac"
          "ont ge 3 mac"
        when "ont ge port 4 mac"
          "ont ge 4 mac"
        else
          value
        end.gsub(' ', '_')

      value = value.pluralize if pluralize == true
      value.to_sym
    end

    def self.is_a_float?(float)
      !!Float(float) rescue false
    end
end
