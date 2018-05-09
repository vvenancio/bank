module Api
  module V1
    class BaseController < ApplicationController
      rescue_from StandardError, with: :internal_server_error
      rescue_from RequestErrors::BadRequest, with: :bad_request
      rescue_from RequestErrors::UnprocessableEntity, with: :unprocessable_entity
      rescue_from RequestErrors::Forbidden, with: :forbidden

      protected

      def bad_request(exception)
        render json: { error: exception.message }, status: :bad_request
      end

      def unprocessable_entity(exception)
        render json: { error: exception.message }, status: :unprocessable_entity
      end

      def internal_server_error(exception)
        render json: { error: exception.message }, status: :internal_server_error
      end

      def forbidden(exception)
        render json: { error: exception.message }, status: :forbidden
      end
    end
  end
end
