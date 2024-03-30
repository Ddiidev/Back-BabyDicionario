module user

import contracts.contract_api { ContractApi, ContractApiNoContent }
import infra.recovery.repository.service as recovery_service
import contracts.token { TokenContractRecoverResponse }
import infra.email.repository.service as email_service
import infra.recovery.entities as recovery_entities
import infra.jwt.repository.service as jwt_service
import infra.repository.repository_users
import contracts.user as cuser
import api.ws_context
import utils.auth
import constants
import x.vweb
import json
import time

const subject = '[DiBebê] Recuperação de senha'

@['/recover-password'; post]
pub fn (ws &WsUser) recover_password_send_email(mut ctx ws_context.Context) vweb.Result {
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

	if !(repository_users.contain_user_with_email(contract.email)
		|| repository_users.contain_user_temp_with_email(contract.email)) {
		ctx.res.set_status(.not_found)
		return ctx.json(ContractApiNoContent{
			message: constants.msg_err_not_found_email
			status: .error
		})
	}

	repo_recovery := recovery_service.get()
	if repo_recovery.email_contains_pendenting_recovery_password(contract.email) {
		ctx.res.set_status(.bad_request)
		return ctx.json(ContractApiNoContent{
			message: constants.msg_err_recovery_contain_recovery_password
			status: .error
		})
	}

	code := auth.random_number()
	body := body_msg_confirmation_recover_user(code)

	handle_jwt := jwt_service.get()
	email := email_service.get()

	email.send(contract.email, user.subject, body) or {
		ctx.res.set_status(.bad_request)
		return ctx.json(ContractApiNoContent{
			message: constants.msg_err_send_email
			status: .error
		})
	}

	expiration_time := time.utc().add(time.minute * 15)
	expiration_time_block := time.utc().add(time.hour * 24)
	tok := handle_jwt.new_jwt(constants.uuid_empty, contract.email, expiration_time.str())

	repo_recovery.new_recovery_password(recovery_entities.UserRecovery{
		email: contract.email
		expiration_time: expiration_time
		expiration_time_block: expiration_time_block
		access_token: tok.str()
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
		content: TokenContractRecoverResponse{
			access_token: tok.str()
		}
	})
}
