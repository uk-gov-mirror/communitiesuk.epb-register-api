# frozen_string_literal: true

module Domain
  class Assessor
    attr_reader :registered_by_id,
                :scheme_assessor_id,
                :domestic_rd_sap_qualification,
                :domestic_sap_qualification,
                :non_domestic_nos3_qualification,
                :non_domestic_nos4_qualification,
                :non_domestic_nos5_qualification

    def initialize(
      scheme_assessor_id: nil,
      first_name: nil,
      last_name: nil,
      middle_names: nil,
      date_of_birth: nil,
      email: nil,
      telephone_number: nil,
      registered_by_id: nil,
      registered_by_name: nil,
      search_results_comparison_postcode: nil,
      also_known_as: nil,
      address_line1: nil,
      address_line2: nil,
      address_line3: nil,
      town: nil,
      postcode: nil,
      company_reg_no: nil,
      company_address_line1: nil,
      company_address_line2: nil,
      company_address_line3: nil,
      company_town: nil,
      company_postcode: nil,
      company_website: nil,
      company_telephone_number: nil,
      company_email: nil,
      company_name: nil,
      domestic_sap_qualification: nil,
      domestic_rd_sap_qualification: nil,
      non_domestic_sp3_qualification: nil,
      non_domestic_cc4_qualification: nil,
      non_domestic_dec_qualification: nil,
      non_domestic_nos3_qualification: nil,
      non_domestic_nos4_qualification: nil,
      non_domestic_nos5_qualification: nil,
      gda_qualification: nil
    )
      @scheme_assessor_id = scheme_assessor_id
      @first_name = first_name
      @last_name = last_name
      @middle_names = middle_names
      @date_of_birth = date_of_birth
      @email = email
      @telephone_number = telephone_number
      @registered_by_id = registered_by_id
      @registered_by_name = registered_by_name
      @search_results_comparison_postcode = search_results_comparison_postcode
      @also_known_as = also_known_as
      @address_line1 = address_line1
      @address_line2 = address_line2
      @address_line3 = address_line3
      @town = town
      @postcode = postcode
      @company_reg_no = company_reg_no
      @company_address_line1 = company_address_line1
      @company_address_line2 = company_address_line2
      @company_address_line3 = company_address_line3
      @company_town = company_town
      @company_postcode = company_postcode
      @company_website = company_website
      @company_telephone_number = company_telephone_number
      @company_email = company_email
      @company_name = company_name
      @domestic_sap_qualification = domestic_sap_qualification
      @domestic_rd_sap_qualification = domestic_rd_sap_qualification
      @non_domestic_sp3_qualification = non_domestic_sp3_qualification
      @non_domestic_cc4_qualification = non_domestic_cc4_qualification
      @non_domestic_dec_qualification = non_domestic_dec_qualification
      @non_domestic_nos3_qualification = non_domestic_nos3_qualification
      @non_domestic_nos4_qualification = non_domestic_nos4_qualification
      @non_domestic_nos5_qualification = non_domestic_nos5_qualification
      @gda_qualification = gda_qualification
    end

    def to_hash
      hash = {
        first_name: @first_name,
        last_name: @last_name,
        registered_by: {
          name: @registered_by_name, scheme_id: @registered_by_id
        },
        scheme_assessor_id: @scheme_assessor_id,
        date_of_birth:
          if @date_of_birth.methods.include?(:strftime)
            @date_of_birth.strftime("%Y-%m-%d")
          else
            Date.parse(@date_of_birth)
          end,
        contact_details: {},
        search_results_comparison_postcode: @search_results_comparison_postcode,
        address: {},
        company_details: {},
        qualifications: {
          domestic_sap: filter_qualification(@domestic_sap_qualification),
          domestic_rd_sap: filter_qualification(@domestic_rd_sap_qualification),
          non_domestic_sp3: filter_qualification(@non_domestic_sp3_qualification),
          non_domestic_cc4: filter_qualification(@non_domestic_cc4_qualification),
          non_domestic_dec: filter_qualification(@non_domestic_dec_qualification),
          non_domestic_nos3: filter_qualification(@non_domestic_nos3_qualification),
          non_domestic_nos4: filter_qualification(@non_domestic_nos4_qualification),
          non_domestic_nos5: filter_qualification(@non_domestic_nos5_qualification),
          gda: filter_qualification(@gda_qualification),
        },
      }

      hash[:contact_details][:email] = @email if @email
      if @telephone_number
        hash[:contact_details][:telephone_number] = @telephone_number
      end
      hash[:middle_names] = @middle_names if @middle_names
      hash[:also_known_as] = @also_known_as if @also_known_as
      hash[:address][:address_line1] = @address_line1 if @address_line1
      hash[:address][:address_line2] = @address_line2 if @address_line2
      hash[:address][:address_line3] = @address_line3 if @address_line3
      hash[:address][:town] = @town if @town
      hash[:address][:postcode] = @postcode if @postcode
      if @company_reg_no
        hash[:company_details][:company_reg_no] = @company_reg_no
      end
      if @company_address_line1
        hash[:company_details][:company_address_line1] = @company_address_line1
      end
      if @company_address_line2
        hash[:company_details][:company_address_line2] = @company_address_line2
      end
      if @company_address_line3
        hash[:company_details][:company_address_line3] = @company_address_line3
      end
      hash[:company_details][:company_town] = @company_town if @company_town
      if @company_postcode
        hash[:company_details][:company_postcode] = @company_postcode
      end
      if @company_website
        hash[:company_details][:company_website] = @company_website
      end
      if @company_telephone_number
        hash[:company_details][:company_telephone_number] =
          @company_telephone_number
      end
      hash[:company_details][:company_email] = @company_email if @company_email
      hash[:company_details][:company_name] = @company_name if @company_name
      hash
    end

    def to_record
      {
        scheme_assessor_id: @scheme_assessor_id,
        first_name: @first_name,
        last_name: @last_name,
        middle_names: @middle_names,
        date_of_birth: @date_of_birth,
        email: @email,
        telephone_number: @telephone_number,
        registered_by: @registered_by_id,
        search_results_comparison_postcode: @search_results_comparison_postcode,
        also_known_as: @also_known_as,
        address_line1: @address_line1,
        address_line2: @address_line2,
        address_line3: @address_line3,
        town: @town,
        postcode: @postcode,
        company_reg_no: @company_reg_no,
        company_address_line1: @company_address_line1,
        company_address_line2: @company_address_line2,
        company_address_line3: @company_address_line3,
        company_town: @company_town,
        company_postcode: @company_postcode,
        company_website: @company_website,
        company_telephone_number: @company_telephone_number,
        company_email: @company_email,
        company_name: @company_name,
        domestic_sap_qualification: @domestic_sap_qualification,
        domestic_rd_sap_qualification: @domestic_rd_sap_qualification,
        non_domestic_sp3_qualification: @non_domestic_sp3_qualification,
        non_domestic_cc4_qualification: @non_domestic_cc4_qualification,
        non_domestic_dec_qualification: @non_domestic_dec_qualification,
        non_domestic_nos3_qualification: @non_domestic_nos3_qualification,
        non_domestic_nos4_qualification: @non_domestic_nos4_qualification,
        non_domestic_nos5_qualification: @non_domestic_nos5_qualification,
        gda_qualification: @gda_qualification,
      }
    end

    private

    def filter_qualification(qualification)
      valid_qualifications = ["ACTIVE", "INACTIVE", "STRUCKOFF", "SUSPENDED"]

      unless valid_qualifications.include? qualification
        return "INACTIVE"
      end
      qualification
    end
  end
end
