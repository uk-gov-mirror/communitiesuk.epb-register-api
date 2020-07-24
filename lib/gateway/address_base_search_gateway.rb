module Gateway
  class AddressBaseSearchGateway
    def search_by_postcode(postcode, _building_name_number, _address_type)
      postcode = postcode.delete " "

      sql =
        "SELECT
            address_line1,
            address_line2,
            address_line3,
            address_line4,
            town,
            postcode,
            uprn
          FROM address_base
          WHERE
            LOWER(REPLACE(postcode, ' ', '')) = $1"

      binds = [
        ActiveRecord::Relation::QueryAttribute.new(
          "postcode",
          postcode.downcase,
          ActiveRecord::Type::String.new,
        ),
      ]

      parse_results ActiveRecord::Base.connection.exec_query sql, "SQL", binds
    end

    def parse_results(results)
      results = results.map { |row| record_to_address_domain row }

      results
    end

    def record_to_address_domain(row)
      Domain::Address.new address_id: row["uprn"],
                          line1: row["address_line1"],
                          line2: row["address_line2"].presence,
                          line3: row["address_line3"].presence,
                          line4: row["address_line4"].presence,
                          town: row["town"],
                          postcode: row["postcode"],
                          source: "ADDRESS_BASE",
                          existing_assessments: nil
    end
  end
end