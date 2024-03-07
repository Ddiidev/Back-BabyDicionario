module confirmation

import contracts.contract_api { ContractApiNoContent }
import infra.repository.repository_recovery
import infra.repository.repository_users
import services.ws_context { Context }
import utils.auth as utils_auth
import contracts.confirmation
import services.email
import services.auth
import constants
import x.vweb
import json

const subject = '[DiBebê] ⚠️ Senha redefinida'

@['/recover-password'; post]
pub fn (ws &WsConfirmation) recover_password_confirmation_code(mut ctx Context) vweb.Result {
	contract := json.decode(confirmation.RecoveryPassword, ctx.req.data) or { confirmation.RecoveryPassword{} }

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

	if !user_recovery.valid_code_confirmation(contract.code_confirmation) {
		ctx.res.set_status(.unprocessable_entity)
		return ctx.json(ContractApiNoContent{
			message: 'Código inválido'
			status: .error
		})
	}

	if user_recovery.valid() {
		repository_users.change_password(user_recovery.email, utils_auth.gen_password(contract.new_password)) or {
			ctx.res.set_status(.bad_request)
			return ctx.json(ContractApiNoContent{
				message: 'Falha na recuperação de senha, tente novamente'
				status: .error
			})
		}

		repository_users.blocked_user_from_recovery_password(user_recovery.email, false) or {
			ctx.res.set_status(.bad_request)
			return ctx.json(ContractApiNoContent{
				message: 'Falha ao desbloquear a conta de usuário, por favor entre em contato com suporte via email'
				status: .error
			})
		}

		body := body_password_redefined(ctx.ip(), auth.create_url_block(user_recovery.access_token),
			contract.current_date)

		defer {
			email.send(user_recovery.email, subject, body) or {
				//TODO: add log
			}
		}
	}

	return ctx.json(ContractApiNoContent{
		message: 'Senha redefinida com sucesso!'
		status: .info
	})
}
