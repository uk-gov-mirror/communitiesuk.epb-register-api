desc "Exporting assessments data for Open Data"

task :open_data_export do
  bucket = ENV["bucket_name"]
  instance_name = ENV["instance_name"]
  assessment_type = ENV["assessment_type"]
  date_from = ENV["date_from"]
  task_id = 0
  unless ENV["task_id"]
    task_id = ENV["task_id"].to_i
  end

  raise Boundary::ArgumentMissing, "ASSESSMENT_TYPE" unless assessment_type
  raise Boundary::ArgumentMissing, "DATE_FROM" unless date_from

  assessment_type = assessment_type.upcase
  open_data_use_case = get_use_case_by_assessment_type(assessment_type)
  raise Boundary::InvalidAssessment, ENV["assessment_type"] unless open_data_use_case

  data = open_data_use_case.execute(date_from, task_id)

  if data.length > 0
    csv_data = Helper::ExportHelper.convert_data_to_csv(data, assessment_type)
    transmit_file(csv_data)
    puts "true"
  else
    puts "no data to export"
  end
rescue Boundary::RecoverableError => e
  error_output = {
    error: e.class.name,
  }

  error_output[:message] = e.message unless e.message == error_output[:error]
  begin
    error_output[:message] = JSON.parse error_output[:message] if error_output[:message]
  rescue JSON::ParserError
    # ignore
  end

rescue Boundary::TerminableError => e
  warn e.message
end

private

def set_date_time
  DateTime.now.strftime("%Y%m%dT%H%M")
end

def transmit_file(data)
  filename = "open_data_export_#{ENV['assessment_type'].downcase}_#{DateTime.now.strftime('%FT%T')}_#{get_max_task_id}.csv"

  storage_config_reader = Gateway::StorageConfigurationReader.new(
    instance_name: ENV["instance_name"],
    bucket_name: ENV["bucket_name"],
  )
  storage_gateway = Gateway::StorageGateway.new(storage_config: storage_config_reader.get_configuration)
  storage_gateway.write_file(filename, data)
end

def get_max_task_id
  gateway = Gateway::OpenDataLogGateway.new
  gateway.fetch_latest_task_id
end

def get_use_case_by_assessment_type(assessment_type)
  open_data_use_case = nil
  case assessment_type
  when "CEPC"
    open_data_use_case = UseCase::ExportOpenDataCommercial.new
  when "CEPC-RR"
    open_data_use_case = UseCase::ExportOpenDataCepcrr.new
  when "DEC"
    open_data_use_case = UseCase::ExportOpenDataDec.new
  when "DEC-RR"
    open_data_use_case = UseCase::ExportOpenDataDecrr.new
  when "SAP-RDSAP"
    open_data_use_case = UseCase::ExportOpenDataDomestic.new
  when "SAP-RDSAP-RR"
    open_data_use_case = UseCase::ExportOpenDataDomesticrr.new
  end
  open_data_use_case
end
