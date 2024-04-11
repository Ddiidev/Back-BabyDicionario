module user

import contracts.contract_api { ContractApiNoContent }
import api.ws_context
import x.vweb
import domain.user.contracts

@['/create/send-code-confirmation'; post]
pub fn (ws &WsUser) crate_user_and_send_confirmation_email(mut ctx ws_context.Context) vweb.Result {
	contract := contracts.ContractEmail.adapter(ctx.req.data) or {
		ctx.res.set_status(.unprocessable_entity)
		return ctx.json(ContractApiNoContent{
			message: 'O JSON fornecido não está de acordo com o contrato esperado.'
			status: .error
		})
	}

	ws.huser_confirmation_service.create(contract) or {
		ctx.json(ContractApiNoContent{
			message: err.msg()
			status: .error
		})
	}

	return ctx.json(ContractApiNoContent{
		message: 'Email enviado com sucesso'
		status: .info
	})
}
