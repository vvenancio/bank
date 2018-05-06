module Api
  module V1
    class PeopleController < Api::V1::BaseController
      def create
        use_case.execute!(user_params)
        head :no_content
      rescue CreatePerson::InvalidAttributes => e
        raise RequestErrors::UnprocessableEntity.new(e.message)
      rescue CreatePerson::InvalidArgument => e
        raise RequestErrors::BadRequest.new(e.message)
      end

      private

      def user_params
        params.require(:payload).permit(:name, :birthdate, :cpf)
      end

      def use_case
        CreatePerson.new
      end
    end
  end
end
