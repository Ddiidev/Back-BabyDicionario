module user

import contracts.contract_api { ContractApi, ContractApiNoContent }
import infra.token.repository.service as token_service
import infra.user.repository.service as user_service
import infra.jwt.repository.service as jwt_service
import infra.token.entities as token_entites
import infra.user.entities as user_entites
import contracts.token as contract_token
import contracts.user { ContractEmail }
import api.ws_context
import utils.auth
import constants
import x.vweb
import json
import rand
import time

@['/login'; post]
pub fn (ws &WsUser) login(mut ctx ws_context.Context) vweb.Result {
	contract := json.decode(ContractEmail, ctx.req.data) or {
		ctx.res.set_status(.unprocessable_entity)
		return ctx.json(ContractApiNoContent{
			message: constants.msg_err_json_contract
			status: .error
		})
	}

	repo_users := user_service.get()
	user_required := repo_users.get_user_by_email_pass(user_entites.User{
		email: contract.email
		password: auth.gen_password(contract.password)
	}) or {
		ctx.res.set_status(.not_found)
		return ctx.json(ContractApiNoContent{
			message: constants.msg_err_email_or_pass
			status: .error
		})
	}

	if user_required.blocked {
		ctx.res.set_status(.unauthorized)
		return ctx.json(ContractApiNoContent{
			message: constants.msg_err_user_blocked
			status: .error
		})
	}

	handle_jwt := jwt_service.get()
	tok_jwt := handle_jwt.new_jwt(user_required.uuid, user_required.email, time.utc().add(time.hour * 5).str())

	mut token := token_entites.Token{
		user_uuid: user_required.uuid
		access_token: tok_jwt.str()
		refresh_token: rand.uuid_v4()
	}
	token.change_refresh_token_expiration_time() or {
		token.refresh_token_expiration = time.utc().add_days(constants.day_expiration_refresh_token)
	}

	repo_tokens := token_service.get()
	repo_tokens.update_token_by_uuid(token) or {
		ctx.res.set_status(.not_found)
		return ctx.json(ContractApiNoContent{
			message: constants.msg_err_email_or_pass
			status: .error
		})
	}

	return ctx.json(ContractApi{
		message: 'Login concluído'
		status: .info
		content: contract_token.TokenContract{
			access_token: token.access_token
			refresh_token: token.refresh_token
		}
	})
}
