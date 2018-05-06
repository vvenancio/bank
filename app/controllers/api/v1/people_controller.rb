module Api
  module V1
    class PeopleController < Api::V1::BaseController
      before_action :find_person, except: :create

      def create
        use_case.create!(use_case_parameters)
        render json: { message: 'Person created!' }, status: :created
      rescue CreatePerson::InvalidAttributes => e
        raise RequestErrors::UnprocessableEntity.new(e.message)
      end

      def update
        if @person.update(person_params)
          return render json: { message: 'Person updated!' }, status: :ok
        end
        raise RequestErrors::BadRequest.new(@person.errors.full_messages)
      end

      def show
        render json: @person, status: :ok
      end

      def destroy
        @person.destroy
        render json: { message: 'Person deleted!' }, status: :ok
      end

      private

      def person_params
        params.require(:person).permit(:name, :birthdate, :cpf)
      end

      def use_case_parameters
        person_params.to_h.symbolize_keys
      end

      def use_case
        CreatePerson.new
      end

      def find_person
        @person = Person.find(params[:id])
      end
    end
  end
end
