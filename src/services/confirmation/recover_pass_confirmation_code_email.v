module confirmation

import contracts.contract_api { ContractApiNoContent }
import infra.repository.repository_recovery
import infra.repository.repository_users
import services.ws_context { Context }
import contracts.confirmation
import services.email
import services.auth
import constants
import x.vweb
import json

const subject = '[DiBebê] ⚠️ Senha redefinida'

@['/recover-password'; post]
pub fn (ws &WsConfirmation) recover_password_confirmation_code(mut ctx Context) vweb.Result {
	contract := json.decode(confirmation.RecoveryPassword, ctx.req.data) or {
		confirmation.RecoveryPassword{}
	}

	if !contract.valid() {
		ctx.res.set_status(.bad_request)
		return ctx.json(ContractApiNoContent{
			message: constants.msg_err_json_contract
			status: .error
		})
	}

	user_recovery := repository_recovery.get_recovery_password(contract.email) or {
		ctx.res.set_status(.not_found)
		return ctx.json(ContractApiNoContent{
			message: err.msg()
			status: .error
		})
	}

	authorization := ctx.req.header.values(.authorization)[0] or { '' }.all_after_last(' ')
	if user_uuid := auth.get_uuid_from_user(authorization) {
		repository_users.change_password(user_uuid, user_recovery.email, contract.new_password) or {
			ctx.res.set_status(.bad_request)
			return ctx.json(ContractApiNoContent{
				message: 'Falha na recuperação de senha, tente novamente'
				status: .error
			})
		}

		body := body_password_redefined(ctx.ip(), auth.create_url_block(user_recovery.access_token), contract.current_date)

		email.send(user_recovery.email, subject, body) or {
			ctx.res.set_status(.bad_request)
			return ctx.json(ContractApiNoContent{
				message: 'Falha no envio do email'
				status: .error
			})
		}
	}

	return ctx.json(ContractApiNoContent{
		message: 'Senha redefinida com sucesso!'
		status: .info
	})
}
