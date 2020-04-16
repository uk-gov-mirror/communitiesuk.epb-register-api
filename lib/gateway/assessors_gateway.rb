module Gateway
  class AssessorsGateway
    SCHEME_ASSESSOR_ID_COLUMN = :scheme_assessor_id
    FIRST_NAME_COLUMN = :first_name
    LAST_NAME_COLUMN = :last_name
    MIDDLE_NAMES_COLUMN = :middle_names
    DATE_OF_BIRTH_COLUMN = :date_of_birth
    EMAIL_COLUMN = :email
    TELEPHONE_NUMBER_COLUMN = :telephone_number
    SEARCH_RESULTS_COMPARISON_POSTCODE_COLUMN =
      :search_results_comparison_postcode
    DOMESTIC_RD_SAP_COLUMN = :domestic_rd_sap_qualification
    NON_DOMESTIC_SP3_COLUMN = :non_domestic_sp3_qualification
    NON_DOMESTIC_CC4_COLUMN = :non_domestic_cc4_qualification
    NON_DOMESTIC_DEC_COLUMN = :non_domestic_dec_qualification
    NON_DOMESTIC_NOS3_COLUMN = :non_domestic_nos3_qualification
    NON_DOMESTIC_NOS4_COLUMN = :non_domestic_nos4_qualification
    NON_DOMESTIC_NOS5_COLUMN = :non_domestic_nos5_qualification
    REGISTERED_BY_COLUMN = :registered_by

    def row_to_assessor_domain(row)
      scheme_name = row['scheme_name']
      unless scheme_name
        scheme = Scheme.find_by(scheme_id: row[REGISTERED_BY_COLUMN.to_s])
        scheme_name = scheme[:name]
      end
      Domain::Assessor.new(
        row[SCHEME_ASSESSOR_ID_COLUMN.to_s],
        row[FIRST_NAME_COLUMN.to_s],
        row[LAST_NAME_COLUMN.to_s],
        row[MIDDLE_NAMES_COLUMN.to_s],
        row[DATE_OF_BIRTH_COLUMN.to_s],
        row[EMAIL_COLUMN.to_s],
        row[TELEPHONE_NUMBER_COLUMN.to_s],
        row[REGISTERED_BY_COLUMN.to_s],
        scheme_name,
        row[SEARCH_RESULTS_COMPARISON_POSTCODE_COLUMN.to_s],
        row[DOMESTIC_RD_SAP_COLUMN.to_s],
        row[NON_DOMESTIC_SP3_COLUMN.to_s],
        row[NON_DOMESTIC_CC4_COLUMN.to_s],
        row[NON_DOMESTIC_DEC_COLUMN.to_s],
        row[NON_DOMESTIC_NOS3_COLUMN.to_s],
        row[NON_DOMESTIC_NOS4_COLUMN.to_s],
        row[NON_DOMESTIC_NOS5_COLUMN.to_s]
      )
    end

    class Assessor < ActiveRecord::Base; end
    class Scheme < ActiveRecord::Base; end

    def qualification_to_column(qualification)
      case qualification
      when 'domesticRdSap'
        DOMESTIC_RD_SAP_COLUMN
      when 'nonDomesticSp3'
        NON_DOMESTIC_SP3_COLUMN
      when 'nonDomesticCc4'
        NON_DOMESTIC_CC4_COLUMN
      when 'nonDomesticDec'
        NON_DOMESTIC_DEC_COLUMN
      when 'nonDomesticNos3'
        NON_DOMESTIC_NOS3_COLUMN
      when 'nonDomesticNos4'
        NON_DOMESTIC_NOS4_COLUMN
      when 'nonDomesticNos5'
        NON_DOMESTIC_NOS5_COLUMN
      else
        raise ArgumentError, 'Unrecognised qualification type'
      end
    end

    def qualification_columns_to_sql(columns)
      first_selectors =
        columns[0...-1].map do |c|
          "#{Assessor.connection.quote_column_name(c)} = 'ACTIVE' OR "
        end
      last_selector =
        "#{Assessor.connection.quote_column_name(columns.last)} = 'ACTIVE' "
      query = first_selectors.join
      query + last_selector
    end

    def fetch(scheme_assessor_id)
      assessor = Assessor.find_by(scheme_assessor_id: scheme_assessor_id)
      assessor ? row_to_assessor_domain(assessor) : nil
    end

    def fetch_list(scheme_id)
      assessors = Assessor.where(registered_by: scheme_id)
      assessors.map { |assessor| row_to_assessor_domain(assessor) }
    end

    def update(assessor)
      existing_assessor =
        Assessor.find_by(scheme_assessor_id: assessor.scheme_assessor_id)
      if existing_assessor
        existing_assessor.update(assessor.to_record)
      else
        Assessor.create(assessor.to_record)
      end
    end

    def search(latitude, longitude, qualifications, entries = 10)
      qualification_selector =
        qualification_columns_to_sql(
          qualifications.map { |q| qualification_to_column(q) }
        )

      binds = [
        ActiveRecord::Relation::QueryAttribute.new(
          'latitude',
          latitude,
          ActiveRecord::Type::Float.new
        ),
        ActiveRecord::Relation::QueryAttribute.new(
          'longitude',
          longitude,
          ActiveRecord::Type::Float.new
        ),
        ActiveRecord::Relation::QueryAttribute.new(
          'entries',
          entries,
          ActiveRecord::Type::Integer.new
        )
      ]

      response =
        Assessor.connection.exec_query(
          "SELECT
          first_name, last_name, middle_names, date_of_birth, registered_by,
           scheme_assessor_id, telephone_number, email, c.name AS scheme_name,
           search_results_comparison_postcode, domestic_rd_sap_qualification,
           non_domestic_sp3_qualification, non_domestic_cc4_qualification,
           non_domestic_dec_qualification, non_domestic_nos3_qualification,
           non_domestic_nos4_qualification, non_domestic_nos5_qualification,
            (
              sqrt(abs(POWER(69.1 * (a.latitude - $1 ), 2) +
              POWER(69.1 * (a.longitude - $2) * cos( $1 / 57.3), 2)))
            ) AS distance
          FROM postcode_geolocation a
          INNER JOIN assessors b ON(b.search_results_comparison_postcode = a.postcode)
          LEFT JOIN schemes c ON(b.registered_by = c.scheme_id)
          WHERE
            #{
            qualification_selector
          }
            AND a.latitude BETWEEN ($1 - 1) AND ($1 + 1)
            AND a.longitude BETWEEN ($2 - 1) AND ($2 + 1)
          ORDER BY distance LIMIT $3",
          'SQL',
          binds
        )

      result = []
      response.each do |row|
        assessor_hash = row_to_assessor_domain(row).to_hash
        assessor_hash[:distance_from_postcode_in_miles] = row['distance']

        result.push(assessor_hash)
      end
      result
    end

    def search_by(
      name: '', max_response_size: 20, loose_match: false, exclude: []
    )
      sql =
        'SELECT
          first_name, last_name, middle_names, date_of_birth, registered_by,
          scheme_assessor_id, telephone_number, email, b.name AS scheme_name,
          search_results_comparison_postcode, domestic_rd_sap_qualification,
          non_domestic_sp3_qualification, non_domestic_cc4_qualification,
          non_domestic_dec_qualification, non_domestic_nos3_qualification,
          non_domestic_nos4_qualification, non_domestic_nos5_qualification

        FROM assessors a
        LEFT JOIN schemes b ON(a.registered_by = b.scheme_id)
        WHERE
          1=1
      '

      unless exclude.empty?
        sql << "AND scheme_assessor_id NOT IN('" + exclude.join("', '") + "')"
      end

      if loose_match
        names = name.split(' ')

        sql <<
          " AND((first_name ILIKE '#{
            ActiveRecord::Base.sanitize_sql(names[0])
          }%' AND last_name ILIKE '#{
            ActiveRecord::Base.sanitize_sql(names[1])
          }%')"
        sql <<
          " OR (first_name ILIKE '#{
            ActiveRecord::Base.sanitize_sql(names[1])
          }%' AND last_name ILIKE '#{
            ActiveRecord::Base.sanitize_sql(names[0])
          }%'))"
      else
        sql <<
          " AND CONCAT(first_name, ' ', last_name) ILIKE '#{
            ActiveRecord::Base.sanitize_sql(name)
          }'"
        sql << 'LIMIT ' + (max_response_size + 1).to_s if max_response_size > 0
      end

      response = Assessor.connection.execute(sql)

      result = []
      response.each { |row| result.push(row_to_assessor_domain(row).to_hash) }
      result
    end
  end
end
