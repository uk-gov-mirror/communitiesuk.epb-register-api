# frozen_string_literal: true

module Controller
  class SchemesController < Controller::BaseController
    POST_SCHEMA = {
      type: 'object',
      required: %w[name],
      properties: { name: { type: 'string' } }
    }.freeze

    get '/api/schemes', jwt_auth: %w[scheme:list] do
      all_schemes = @container.get_object(:get_all_schemes_use_case).execute
      json_api_response(code: 200, data: all_schemes)
    end

    post '/api/schemes', jwt_auth: %w[scheme:create] do
      new_scheme_details = request_body(POST_SCHEMA)
      result =
        @container.get_object(:add_new_scheme_use_case).execute(
          new_scheme_details[:name]
        )
      json_api_response(code: 201, data: result)
    rescue StandardError => e
      case e
      when JSON::Schema::ValidationError, JSON::ParserError
        error_response(401, 'INVALID_REQUEST', e.message)
      when Gateway::SchemesGateway::DuplicateSchemeException
        error_response(
          400,
          'DUPLICATE_SCHEME',
          'Scheme with this name already exists'
        )
      else
        server_error(e.message)
      end
    end
  end
end
