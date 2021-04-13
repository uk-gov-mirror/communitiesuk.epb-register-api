module Gateway
  class AssessmentAttributesGateway
    def add_attribute(attribute_name)
      attribute_data = fetch_attribute_id(attribute_name)
      if attribute_data.nil?
        insert(attribute_name)
      else
        attribute_data["attribute_id"]
      end
    end


    def add_attribute_value(attribute_name, value)

    end

  private

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

    def insert(attribute_name)
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
  end
end
