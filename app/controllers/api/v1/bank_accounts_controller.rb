# TODO: Quando for fazer um estorno, chamar o método de transfrência,
# referênciando as contas de maneira inversa, e passando o valor a ser transferido

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
        deposit_use_case.deposit!(bank_account_id: @bank_account.id, value: params[:value])
        head :no_content
      rescue Deposit::NotAllowedTo => e
        raise RequestErrors::Forbidden.new(e.message)
      rescue Deposit::AttributeMissing => e
        raise RequestErrors::BadRequest.new(e.message)
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

      def deposit_use_case
        Deposit.new
      end

      def find_bank_account
        @bank_account = BankAccount.find(params[:id])
      end
    end
  end
end
