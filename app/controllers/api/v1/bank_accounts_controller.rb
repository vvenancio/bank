module Api
  module V1
    class BankAccountsController < Api::V1::BaseController
      before_action :find_bank_account, except: :create

      def create
        use_case.create!(use_case_parameters)
        render json: { message: 'Bank account created!' }, status: :created
      rescue CreatePerson::InvalidAttributes => e
        raise RequestErrors::UnprocessableEntity.new(e.message)
      end

      def show
        render json: @bank_account, status: :ok
      end

      def update
        if @bank_account.update(bank_account_params)
          return render json: { message: 'Bank account updated!' }, status: :ok
        end
        raise RequestErrors::BadRequest.new(@bank_account.errors.full_messages)
      end

      def destroy
        @bank_account.destroy
        render json: { message: 'Bank account deleted!' }, status: :ok
      end

      def deposit
        raise RequestErrors::Forbidden.new('Account should be active to receive some deposit!') unless @bank_account.active?
        raise RequestErrors::BadRequest.new('Deposit value must be provided!') if params[:value].blank?
        value = BigDecimal.new(params[:value])
        @bank_account.balance += value
        @bank_account.save!
        head :no_content
      end

      private

      def use_case_parameters
        bank_account_params.to_h.symbolize_keys
      end

      def bank_account_params
        params.require(:bank_account).permit(:owner, :parent_id, :name, :status)
      end

      def use_case
        CreateBankAccount.new
      end

      def find_bank_account
        @bank_account = BankAccount.find(params[:id])
      end
    end
  end
end
