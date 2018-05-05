module Api
  module V1
    class RegistrationsController < Api::V1::BaseController
      def create
        use_case = registrations_use_case
        use_case.execute!(registrations_params)
        head :no_content
      rescue GenericErrors::InvalidAttributesException => e
        raise RequestErrors::UnprocessableEntity.new(e.message)
      end

      private

      def registrations_params
        params.require(:payload).permit :name,
                                        :birthdate,
                                        :cpf,
                                        :cnpj
      end

      def registrations_use_case
        Registration.new
      end
    end
  end
end
