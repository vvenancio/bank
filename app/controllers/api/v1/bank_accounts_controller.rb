# TODO: Quando for fazer um estorno, chamar o método de transfrência,
# referênciando as contas de maneira inversa, e passando o valor a ser transferido

module Api
  module V1
    class BankAccountsController < Api::V1::BaseController
      before_action :validate_parameter, only: :update
      before_action :find_bank_account, except: [:create, :transfer]

      def create
        account = use_case.create!(use_case_parameters)
        render json: { id: account.id }, status: :created
      rescue CreateBankAccount::InvalidAttributes => e
        raise RequestErrors::UnprocessableEntity.new(e.message)
      rescue CreateBankAccount::ResourceNotFound => e
        raise RequestErrors::NotFound.new(e.message)
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

      def transfer
        from_account = BankAccount.find(params[:from_account_id])
        to_account = BankAccount.find(params[:to_account_id])
        history = transference_use_case.transfer!(from_account: from_account, to_account: to_account, value: params[:value])
        render json: { token: history.token }, status: :ok
      rescue Accounts::Transfer::NotAllowedTo => e
        raise RequestErrors::Forbidden.new(e.message)
      end

      def deposit
        deposit_use_case.deposit!(bank_account_id: @bank_account.id, value: params[:value])
        head :no_content
      rescue Accounts::Deposit::NotAllowedTo => e
        raise RequestErrors::Forbidden.new(e.message)
      rescue Accounts::Deposit::AttributeMissing => e
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
        Accounts::Deposit.new
      end

      def transference_use_case
        Accounts::Transfer.new
      end

      def find_bank_account
        @bank_account = BankAccount.find(params[:id])
      end

      def validate_parameter
        status = params[:bank_account][:status]
        if status.present? && BankAccount.statuses.exclude?(status)
          raise RequestErrors::BadRequest.new('Status should be valid!')
        end
      end
    end
  end
end
