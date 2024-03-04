module user

import contracts.contract_api { ContractApiNoContent, ContractApi }
import infra.repository.repository_tokens
import contracts.token as contract_token
import infra.repository.repository_users
import contracts.user { ContractEmail }
import services.ws_context { Context }
import services.handle_jwt
import infra.entities
import utils.auth
import constants
import x.vweb
import json
import rand
import time

@['/login'; post]
pub fn (ws &WsUser) login(mut ctx Context) vweb.Result {

	contract := json.decode(ContractEmail, ctx.req.data) or {
		ctx.res.set_status(.unprocessable_entity)
		return ctx.json(ContractApiNoContent{
			message: constants.msg_err_json_contract
			status: .error
		})
	}

	user_required := repository_users.get_user_by_email_pass(entities.User{
		email: contract.email
		senha: auth.gen_password(contract.password)
	}) or {
		ctx.res.set_status(.not_found)
		return ctx.json(ContractApiNoContent{
			message: constants.msg_err_email_or_pass
			status: .error
		})
	}

	tok_jwt := handle_jwt.new_jwt(
		user_required.uuid,
		user_required.email,
		time.utc().add(time.hour * 5).str()
	)

	mut token := entities.Token{
		user_uuid: user_required.uuid
		access_token: tok_jwt.str()
		refresh_token: rand.uuid_v4()
	}
	token.change_refresh_token_expiration_time() or {
		token.refresh_token_expiration = time.utc().add_days(constants.day_expiration_refresh_token)
	}

	repository_tokens.update_token_by_uuid(token) or {
		ctx.res.set_status(.not_found)
		return ctx.json(ContractApiNoContent{
			message: constants.msg_err_email_or_pass
			status: .error
		})
	}

	return ctx.json(ContractApi{
		message: "Login concluído"
		status: .info
		content: contract_token.TokenContract{
			access_token: token.access_token
			refresh_token: token.refresh_token
		}
	})
}