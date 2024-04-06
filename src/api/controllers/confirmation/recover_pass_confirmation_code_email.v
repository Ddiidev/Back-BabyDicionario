module confirmation

import contracts.contract_api { ContractApiNoContent }
import domain.user.contracts as user_contract
import domain.user.errors
import api.ws_context
import x.vweb

@['/recover-password'; post]
pub fn (ws &WsConfirmation) recover_password_confirmation_code(mut ctx ws_context.Context) vweb.Result {
	contract := user_contract.RecoveryPassword.adapter(ctx.req.data) or {
		ctx.res.set_status(.unprocessable_entity)
		return ctx.json(ContractApiNoContent{
			message: 'O JSON fornecido não está de acordo com o contrato esperado.'
			status: .error
		})
	}

	ws.hrecovery_service.recover_password(contract) or {
		match err {
			errors.UserErrorCodeInvaild {
				ctx.res.set_status(.unprocessable_entity)
			}
			else {
				ctx.res.set_status(.bad_request)
			}
		}

		return ctx.json(ContractApiNoContent{
			message: err.msg()
			status: .error
		})
	}

	return ctx.json(ContractApiNoContent{
		message: 'Senha redefinida com sucesso!'
		status: .info
	})
}
