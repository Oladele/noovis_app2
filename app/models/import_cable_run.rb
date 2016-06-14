class ImportCableRun
  include ActiveModel::Model
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :file, :sheet, :building_id, :filename
  attr_reader :message, :status, :workbook, :building

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }

    set_status(:bad_request, "Workbook file required") and return unless file
    set_status(:bad_request, "Sheet requried") and return unless sheet
    set_status(:bad_request, "Building id required") and return unless building_id

    return unless set_building
    set_filename unless @filename.present?  # Background job file doesn't have an `original_filename` method
    return unless open_workbook
    return unless set_sheet

    set_status :created, "Ready for processing." # Not sure :created still makes sense here

    return self
  end

  def process!
    import_job = ImportJob.create!(
      building_id: self.building_id,
      spreadsheet: self.file.tempfile,
      sheet_name: self.sheet,
      filename: file.original_filename,
      status: 'processing'
    )

    ImportCableRunProcessingWorker.perform_async(import_job.id)
  end

  def set_building
    @building = Building.find_by_id building_id
    if @building
      true
    else
      set_status(:unprocessable_entity, "Building could not be found: Building ID: #{building_id}")
      false
    end
  end

  def set_filename
    @filename = file.original_filename
  end

  def open_workbook
    case File.extname(@filename)
    when '.xls' then @workbook = Roo::Spreadsheet.open(file, extension: :xls)
    when '.xlsx' then @workbook = Roo::Excelx.new(file)
    else
      set_status(:unsupported_media_type, "Unknown file type: #{@filename}") and return
    end
  end

  def set_sheet
    begin
      @workbook.default_sheet = sheet
    rescue RangeError
      set_status :unprocessable_entity,
        "Invalid sheet name: #{sheet}"
      return false
    end

    return true
  end

  def save_cable_run
    missing_fields = imported_cable_runs[:header_errors][:missing_fields]
    #extra_fields = imported_cable_runs[:header_errors][:extra_fields]

    unless missing_fields.empty?
      field_errors = []

      missing_fields.each do |field|
        field_errors << "HEADER #{field} is missing"
      end

      set_status :unprocessable_entity,
        "Cannot create cable runs: #{field_errors * ', '}"

      return false
    end

    if imported_cable_runs[:cable_runs].map(&:valid?).all?
      imported_cable_runs[:cable_runs].each do |cr|
        count_of_nils = 0
        cr.attributes.each do |key,value|
          if value.blank?
            count_of_nils +=1
            cr[key] = "N/A" unless key == "id"
          end
        end
        if count_of_nils < (cr.attributes.length-1)
          #cr.without_versioning :save
          cr.save
        end
      end
    else
      product_errors = []

      imported_cable_runs[:cable_runs].each_with_index do |product, index|
        product.errors.full_messages.each do |message|
          product_errors << "Row #{index+2}: #{message}"
        end
      end

      set_status :unprocessable_entity,
        "Cannot create cable runs: #{product_errors * ', '}"

      return false
    end

    set_status :created, "Successfully created cable runs"
    true
  end

  def save_sheet(book)
    @workbook_sheet = Sheet.new(name: @sheet, workbook: book, building_id: @building_id)

    if @workbook_sheet.save
      save_cable_run

      NetworkGraph.destroy_all_for(@workbook_sheet.building)

      graph = SpreadsheetImporter.import_from_cable_runs(SpreadsheetImporter::NETWORK_TEMPLATE, @workbook_sheet.cable_runs)
      NetworkGraph.create_from_graph(@workbook_sheet, graph)
    else
      set_status :unprocessable_entity,
        "Cannot create sheet #{@sheet} for workbook #{@filename}: #{@workbook_sheet.errors.full_messages}"
    end
  end

  def save_workbook
    existing = Workbook.where(name: @filename).last

    if existing
      save_sheet(existing)
    else
      new_workbook = Workbook.new(name: @filename, network_site: @building.network_site)
      if new_workbook.save
        save_sheet(new_workbook)
      else
        set_status :unprocessable_entity,
          "Cannot create workbook #{@filename}: #{new_workbook.errors.full_messages}"
      end
    end
  end

  def import_cable_runs
    first_row_index = @workbook.first_row
    header = @workbook.row(first_row_index)
    fields = CableRun.header_to_fields header

    #fields = {
    #  extra: [],
    #  extra_friendlies: [],
    #  missing: [],
    #  missing_friendlies: [],
    #  valid: [],
    #  valid_indices: [],
    #  valid_friendlies: []
    #}

    header = fields[:valid]
    valid_indices = fields[:valid_indices]
    header_errors = {
      extra_fields: fields[:extra],
      missing_fields: fields[:missing]
    }

    cable_runs = []

    data_row_index = first_row_index + 1
    cable_runs = (data_row_index..@workbook.last_row).map do |i|
      workbook_row = []
      @workbook.row(i).each_with_index do |item, index|
        workbook_row << item if valid_indices.include? index
      end

      row = Hash[[header, workbook_row].transpose]
      row["sheet_id"] = @workbook_sheet.id
      cable_run = CableRun.new row.to_hash.slice(*CableRun.attribute_names)
      cable_run
    end

    {
      header: header,
      header_errors: header_errors,
      cable_runs: cable_runs
    }
  end

  def imported_cable_runs
    @imported_cable_runs ||= import_cable_runs
  end

  def set_status(status, message)
    @status = status
    @message = message
  end

  def as_json(options={})
    super(only: [:message, :status])
  end
end
