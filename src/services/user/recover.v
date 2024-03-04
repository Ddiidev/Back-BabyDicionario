module user

import contracts.contract_api { ContractApi, ContractApiNoContent }
import infra.repository.repository_users
import services.ws_context { Context }
import contracts.user as cuser
import services.handle_jwt
import infra.entities
import services.email
import utils.auth
import constants
import x.vweb
import json
import time

const subject = '[DiBebê] Recuperação de senha'

@['/recover-password'; post]
pub fn (ws &WsUser) recover_password_send_email(mut ctx Context) vweb.Result {
	contract := json.decode(cuser.ContractUser, ctx.req.data) or {
		ctx.res.set_status(.bad_request)
		return ctx.json(ContractApiNoContent{
			message: constants.msg_err_json_contract
			status: .error
		})
	}

	if !contract.valid_email() {
		ctx.res.set_status(.bad_request)
		return ctx.json(ContractApiNoContent{
			message: constants.msg_err_json_contract
			status: .error
		})
	}

	code := auth.random_number()
	body := body_msg_confirmation_recover_user(code)

	email.send(contract.email, subject, body) or {
		ctx.res.set_status(.bad_request)
		return ctx.json(ContractApiNoContent{
			message: constants.msg_err_send_email
			status: .error
		})
	}

	expiration_time := time.utc().add(time.hour * 5)
	token := handle_jwt.new_jwt(constants.uuid_empty, contract.email, expiration_time.str())

	repository_users.new_recovery_password(entities.UserRecovery{
		email: contract.email
		expiration_time: expiration_time
		access_token: token.str()
		code_confirmation: code
	}) or {
		ctx.res.set_status(.bad_request)
		return ctx.json(ContractApiNoContent{
			message: constants.msg_err_send_email
			status: .error
		})
	}

	return ctx.json(ContractApi{
		message: constants.msg_send_email
		status: .info
		content: token.str()
	})
}
