module Controller
  class AddressSearchController < Controller::BaseController
    SEARCH_SCHEMA = {
      type: "object",
      required: %w[buildingReferenceNumber],
      properties: {
        buildingReferenceNumber: {
          type: "string", pattern: "^RRN-(\\d{4}-){4}\\d{4}$"
        },
      },
    }.freeze

    get "/api/search/addresses", jwt_auth: %w[address:search] do
      filters = params_body SEARCH_SCHEMA

      results =
        @container.get_object(
          :search_addresses_by_building_reference_number_use_case,
        )
          .execute(filters)

      json_api_response code: 200,
                        data: { addresses: results.map(&:to_hash) },
                        meta: { filters: filters }
    rescue StandardError => e
      case e
      when JSON::Schema::ValidationError
        error_response(422, "INVALID_REQUEST", e.message)
      else
        server_error(e)
      end
    end
  end
end