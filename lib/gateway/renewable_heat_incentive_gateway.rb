module Gateway
  class RenewableHeatIncentiveGateway
    TENURE = {
      "1" => "Owner-occupied",
      "2" => "Rented (social)",
      "3" => "Rented (private)",
      "ND" => "Unknown",
    }.freeze

    class Assessor < ActiveRecord::Base; end

    def fetch(assessment_id)
      sql =
        "SELECT
          scheme_assessor_id, assessment_id, date_of_assessment, date_registered, dwelling_type,
          type_of_assessment, total_floor_area, current_energy_efficiency_rating,
          potential_energy_efficiency_rating, postcode, current_space_heating_demand,
          current_water_heating_demand, impact_of_loft_insulation, tenure, property_age_band,
          impact_of_cavity_insulation, property_summary
          FROM assessments
        WHERE assessment_id = $1 AND type_of_assessment IN('RdSAP', 'SAP')"

      binds = [
        ActiveRecord::Relation::QueryAttribute.new(
          "id",
          assessment_id,
          ActiveRecord::Type::String.new,
        ),
      ]

      results = ActiveRecord::Base.connection.exec_query sql, "SQL", binds

      result = results.map { |row| record_to_rhi_domain row }

      result.reduce
    end

  private

    def record_to_rhi_domain(row)
      Domain::RenewableHeatIncentive.new(
        epc_rrn: row["assessment_id"],
        assessor_name: fetch_assessor_name(row["scheme_assessor_id"]),
        report_type: row["type_of_assessment"],
        inspection_date: row["date_registered"],
        lodgement_date: row["date_of_assessment"],
        dwelling_type: row["dwelling_type"],
        postcode: row["postcode"],
        property_age_band: row["property_age_band"],
        tenure: TENURE[row["tenure"]],
        total_floor_area: row["total_floor_area"],
        cavity_wall_insulation:
          row["impact_of_cavity_insulation"] ? true : false,
        loft_insulation: row["impact_of_loft_insulation"] ? true : false,
        space_heating:
          fetch_property_description(row["property_summary"], "main_heating"),
        water_heating:
          fetch_property_description(row["property_summary"], "hot_water"),
        secondary_heating:
          fetch_property_description(
            row["property_summary"],
            "secondary_heating",
          ),
        energy_efficiency: {
          current_rating: row["current_energy_efficiency_rating"],
          current_band:
            get_energy_rating_band(row["current_energy_efficiency_rating"]),
          potential_rating: row["potential_energy_efficiency_rating"],
          potential_band:
            get_energy_rating_band(row["potential_energy_efficiency_rating"]),
        },
      )
    end

    def fetch_assessor_name(scheme_assessor_id)
      assessor = Assessor.find_by(scheme_assessor_id: scheme_assessor_id)
      assessor_full_name =
        "#{assessor['first_name']} #{assessor['middle_names']} #{
          assessor['last_name']
        }"
      assessor_full_name
    end

    def fetch_property_description(property, name)
      summary = JSON.parse property

      summary.each do |property|
        return property["description"] if property["name"] == name
      end

      nil
    end

    def get_energy_rating_band(number)
      case number
      when 1..20
        "g"
      when 21..38
        "f"
      when 39..54
        "e"
      when 55..68
        "d"
      when 69..80
        "c"
      when 81..91
        "b"
      when 92..1_000
        "a"
      end
    end
  end
end