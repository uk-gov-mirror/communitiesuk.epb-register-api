module Gateway
  class AssessorsGateway
    class Assessor < ActiveRecord::Base
      def to_hash
        {
          first_name: self[:first_name],
          last_name: self[:last_name],
          middle_names: self[:middle_names],
          registered_by: self[:registered_by],
          scheme_assessor_id: self[:scheme_assessor_id],
          date_of_birth: self[:date_of_birth].strftime('%Y-%m-%d'),
          contact_details: {
            telephone_number: self[:telephone_number],
            email: self[:email]
          }
        }
      end
    end

    def fetch(scheme_assessor_id)
      assessor = Assessor.find_by(scheme_assessor_id: scheme_assessor_id)
      assessor ? assessor.to_hash : nil
    end

    def update(scheme_assessor_id, registered_by, assessor_details)
      assessor = assessor_details.dup
      assessor[:registered_by] = registered_by
      assessor[:scheme_assessor_id] = scheme_assessor_id

      existing_assessor =
        Assessor.find_by(
          scheme_assessor_id: scheme_assessor_id, registered_by: registered_by
        )

      assessor = flatten(assessor)

      if existing_assessor
        existing_assessor.update(assessor)
      else
        Assessor.create(assessor)
      end
    end

  private

    def flatten(assessor)
      assessor[:telephone_number] = assessor.key?(:contact_details)?assessor[:contact_details][:telephone_number]:''
      assessor[:email] = assessor.key?(:contact_details)?assessor[:contact_details][:email]:''
      assessor.delete(:contact_details)
      assessor
    end
  end
end
