class ImportCableRun
  include ActiveModel::Model
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :file, :sheet, :building_id
  attr_reader :message, :status, :filename, :workbook, :building

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }

    #set_status(:bad_request, "Workbook file required") and return unless file
    set_status(:bad_request, "Sheet requried") and return unless sheet
    set_status(:bad_request, "Building id required") and return unless building_id

    return unless set_building
    set_filename
    return unless open_workbook
    set_sheet
    save_workbook
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
    when '.csv' then @workbook = Roo::Csv.new(file)
    when '.xls' then @workbook = Roo::Spreadsheet.open(file, extension: :xls)
    when '.xlsx' then @workbook = Roo::Excelx.new(file)
    else
      set_status(:unsupported_media_type, "Unknown file type: #{@filename}") and return
    end
  end

  def set_sheet
    @workbook.default_sheet = sheet
  end

  def save_cable_run
    set_status :created, "Successfully created cable runs"
  end

  def save_sheet(book)
    Sheet.where(name: @sheet, workbook: book).destroy_all

    new_sheet = Sheet.new(name: @sheet, workbook: book, building_id: @building_id)
    
    if new_sheet.save
      save_cable_run
    else
      set_status :unprocessable_entity,
        "Cannot create sheet #{@sheet} for workbook #{@filename}: #{new_sheet.errors.full_messages}"
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

  def set_status(status, message)
    @status = status
    @message = message
  end

  def as_json(options={})
    super(only: [:message, :status])
  end
end
