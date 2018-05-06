module Api
  module V1
    class CompaniesController < Api::V1::BaseController
      before_action :find_company, except: :create

      def create
        use_case.create!(use_case_parameters)
        render json: { message: 'Company created!' }, status: :created
      rescue CreateCompany::InvalidAttributes => e
        raise RequestErrors::UnprocessableEntity.new(e.message)
      end

      def update
        if @company.update(company_params)
          return render json: { message: 'Company updated!' }, status: :ok
        end
        raise RequestErrors::BadRequest.new(@company.errors.full_messages)
      end

      def show
        render json: @company, status: :ok
      end

      def destroy
        @company.destroy
        render json: { message: 'Company deleted!' }, status: :ok
      end

      private

      def company_params
        params.require(:company).permit(:name, :trade, :cnpj)
      end

      def use_case_parameters
        company_params.to_h.symbolize_keys
      end

      def use_case
        CreateCompany.new
      end

      def find_company
        @company = Company.find(params[:id])
      end
    end
  end
end
