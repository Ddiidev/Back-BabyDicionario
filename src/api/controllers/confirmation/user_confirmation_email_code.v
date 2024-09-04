module confirmation

import contracts.contract_api { ContractApi, ContractApiNoContent }
import domain.user.contracts as domain_user_contracts
import domain.email.contracts as email_contract
import domain.email.application_service
import api.ws_context
import veb

@['/'; post]
pub fn (ws &WsConfirmation) confirmation_user_by_email_and_code(mut ctx ws_context.Context) veb.Result {
	contract := email_contract.ConfirmationEmailByCode.adapter(ctx.req.data) or {
		ctx.res.set_status(.unprocessable_entity)
		return ctx.json(ContractApiNoContent{
			message: 'O JSON fornecido não está de acordo com o contrato esperado.'
			status:  .error
		})
	}

	token_model := application_service.confirm_email_by_code(contract) or {
		ctx.res.set_status(.bad_request)

		return ctx.json(ContractApiNoContent{
			message: err.msg()
			status:  .error
		})
	}

	return ctx.json(ContractApi{
		message: 'Usuário verificado com sucesso!'
		status:  .info
		content: domain_user_contracts.TokenContract.new(
			access_token:  token_model.access_token
			refresh_token: token_model.refresh_token
		)
	})
}
