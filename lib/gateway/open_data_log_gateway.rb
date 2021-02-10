module Gateway
  class OpenDataLogGateway
    def insert(assessment_id, task_id)
      insert_sql = <<-SQL
            INSERT INTO open_data_logs(assessment_id, created_at, task_id)
            VALUES ($1, $2, $3)
      SQL

      bindings = [
        ActiveRecord::Relation::QueryAttribute.new(
          "assessment_id",
          assessment_id,
          ActiveRecord::Type::String.new,
        ),
        ActiveRecord::Relation::QueryAttribute.new(
          "created_at",
          DateTime.now,
          ActiveRecord::Type::DateTime.new,
        ),
        ActiveRecord::Relation::QueryAttribute.new(
          "task_id",
          task_id,
          ActiveRecord::Type::BigInteger.new,
        ),
      ]

      ActiveRecord::Base.connection.exec_query(insert_sql, "SQL", bindings)
      assessment_id
    end

    def get_statistics
      sql = <<-SQL
              SELECT Count(*) as num_rows, Min(created_at) as date_start, Max(created_at) as date_end, (Max(created_at) - Min(created_at)) as execution_time
              FROM open_data_logs
              GROUP BY task_id
              ORDER BY  Max(created_at)
      SQL
      results = ActiveRecord::Base.connection.exec_query(sql)
      results.map { |result| result }
    end

    # TODO: Add delete method for testing
  end
end