module Gateway
  class AssessmentAttributesGateway
    # TODO: Add rrn constant and set to "asessement_id"
    RRN = "assessment_id".freeze
    HASH_RRN = "hashed_assessment_id".freeze
    attr_accessor :attribute_columns_array

    def initialize
      @attribute_columns_array = []
    end

    def add_attribute(attribute_name)
      attribute_data = fetch_attribute_id(attribute_name)
      if attribute_data.nil?
        insert_attribute(attribute_name)
      else
        attribute_data["attribute_id"]
      end
    end

    def add_attribute_value(asessement_id, attribute_name, attribute_value)
      unless attribute_value.empty?
        unless attribute_name.to_s == RRN
          ActiveRecord::Base.transaction do
            attribute_id = add_attribute(attribute_name)
            insert_attribute_value(asessement_id, attribute_id, attribute_value)
          end
        end
      end
    end

    def delete_attributes_by_assessment(assessment_id)
      sql = <<-SQL
              DELETE FROM assessment_attribute_values
              WHERE assessment_id = $1
      SQL

      bindings = [
        ActiveRecord::Relation::QueryAttribute.new(
          "assessment_id",
          assessment_id,
          ActiveRecord::Type::String.new,
        ),
      ]

      ActiveRecord::Base.connection.exec_query(sql, "SQL", bindings)
    end

    def fetch_assessments_to_add
      sql = <<-SQL
             SELECT a.assessment_id
              FROM assessments a
              WHERE NOT EXISTS (
                  SELECT * FROM assessment_attribute_values av WHERE av.assessment_id = a.assessment_id
            )
      SQL

      ActiveRecord::Base
        .connection
        .exec_query(sql, "SQL")
        .map { |result| result }
    end

    # SELECT hashed_assessment_id as assessment_id,
    #        heating_cost_potential,
    #         COALESCE(total_floor_area, null) as total_floor_area
    #   FROM crosstab($$
    # SELECT  assessment_id,  attribute_name, attribute_value
    # FROM assessment_attribute_values
    # JOIN assessment_attributes ON assessment_attribute_values.attribute_id = assessment_attributes.attribute_id
    # WHERE assessment_attributes.attribute_name IN ('heating_cost_potential', 'total_floor_area')
    #  ORDER BY assessment_id,
    #     CASE attribute_name WHEN  CASE attribute_name WHEN  'hashed_assessment_id' THEN 1 WHEN 'heating_cost_potential' THEN 2 WHEN 'total_floor_area' THEN '3' WHEN 'posttown' THEN '4' ELSE 5 END
    # $$)
    # AS column_names(assessment_id varchar, heating_cost_potential varchar, total_floor_area varchar)

    def fetch_assessment_attributes(attribute_column_array)
      @attribute_columns_array = attribute_column_array.sort
      where_clause = attribute_where_clause
      number_attributes = where_clause.split(",").count
      virtual_columns = virtual_column_types
      select = select_columns
      sql = <<-SQL
              SELECT assessment_id, #{select}
              FROM crosstab($$
              SELECT  assessment_id, attribute_name, attribute_value
              FROM assessment_attribute_values av
              JOIN assessment_attributes a ON av.attribute_id = a.attribute_id
              WHERE a.attribute_name IN (#{where_clause})
              ORDER BY assessment_id, #{order_sequence}
              $$)
            AS virtual_columns(#{virtual_columns})
      SQL

      ActiveRecord::Base.connection.exec_query(sql, "SQL")
    end

  private

    def attribute_where_clause
      new_array = @attribute_columns_array.clone
      new_array.map! { |i| "'#{i}'" }
      new_array.join(",")
    end

    def virtual_column_types
      new_array = @attribute_columns_array.clone
      new_array = rrn_into_array(new_array)
      new_array.map! { |name| name + " varchar" }
      new_array.join(", ")
    end

    def select_columns
      select_array = @attribute_columns_array.clone
      select_array.map! { |item| " COALESCE(#{item}, null) AS #{item} " }
      select_array.join(",")
    end

    def order_sequence
      order_by_string = "CASE attribute_name "
      @attribute_columns_array.each_with_index do |value, index|
        order_by_string << " WHEN '#{value}' THEN #{(index + 1)}"
      end
      order_by_string << +" ELSE #{@attribute_columns_array.count + 1} END"
    end

    def rrn_into_array(column_array)
      position = column_array.find_index(RRN)
      if position.nil?
        column_array.insert(0, RRN)
      elsif position > 0
        column_array.insert(0, column_array.delete_at(position))
      end
      column_array
    end

    def fetch_attribute_id(attribute_name)
      sql = <<-SQL
             SELECT attribute_id
              FROM assessment_attributes WHERE attribute_name = $1
              LIMIT 1
      SQL
      ActiveRecord::Base
        .connection
        .exec_query(sql, "SQL", attribute_name_binding(attribute_name))
        .first
    end

    def attribute_name_binding(attribute_name)
      bindings = [
        ActiveRecord::Relation::QueryAttribute.new(
          "attribute_name",
          attribute_name,
          ActiveRecord::Type::String.new,
        ),
      ]
    end

    def insert_attribute(attribute_name)
      insert_sql = <<-SQL
              INSERT INTO assessment_attributes(attribute_name)
              VALUES($1)
      SQL

      ActiveRecord::Base.connection.insert(
        insert_sql,
        nil,
        nil,
        nil,
        nil,
        attribute_name_binding(attribute_name),
      )
    end

    def insert_attribute_value(assessment_id, attribute_id, attribute_value)
      sql = <<-SQL
              INSERT INTO assessment_attribute_values(assessment_id, attribute_id, attribute_value, attribute_value_int, attribute_value_float)
              VALUES($1, $2, $3, $4, $5)
      SQL

      attribute_value_int =
        begin
          Integer(attribute_value)
        rescue StandardError
          nil
        end
      attribute_value_float =
        begin
          Float(attribute_value)
        rescue StandardError
          nil
        end

      bindings = [
        ActiveRecord::Relation::QueryAttribute.new(
          "assessment_id",
          assessment_id,
          ActiveRecord::Type::String.new,
        ),
        ActiveRecord::Relation::QueryAttribute.new(
          "attribute_id",
          attribute_id,
          ActiveRecord::Type::BigInteger.new,
        ),
        ActiveRecord::Relation::QueryAttribute.new(
          "attribute_value",
          attribute_value,
          ActiveRecord::Type::String.new,
        ),
        ActiveRecord::Relation::QueryAttribute.new(
          "attribute_int",
          attribute_value_int,
          ActiveRecord::Type::BigInteger.new,
        ),
        ActiveRecord::Relation::QueryAttribute.new(
          "attribute_float",
          attribute_value_float,
          ActiveRecord::Type::Decimal.new,
        ),
      ]

      ActiveRecord::Base.connection.insert(sql, nil, nil, nil, nil, bindings)
    end
  end
end
