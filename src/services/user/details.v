module user

import contracts.contract_api { ContractApi, ContractApiNoContent }
import infra.repository.repository_users
import services.ws_context { Context }
import contracts.user as cuser
import infra.entities
import services.auth
import constants
import x.vweb

@['/details']
pub fn (ws &WsUser) dails_user(mut ctx Context) vweb.Result {
	authorization := ctx.req.header.values(.authorization)[0] or { '' }.all_after_last(' ')

	user_uuid := auth.get_uuid_from_user(authorization) or {
		ctx.res.set_status(.not_found)
		return ctx.json(ContractApiNoContent{
			message: constants.msg_err_token_invalid
			status: .error
		})
	}

	user := repository_users.get_user_by_uuid(entities.User{
		uuid: user_uuid
	}) or {
		ctx.res.set_status(.not_found)
		return ctx.json(ContractApiNoContent{
			message: constants.msg_err_user_not_found
			status: .error
		})
	}

	return ctx.json(ContractApi{
		message: constants.msg_user_found
		status: .info
		content: cuser.ContractUser{
			first_name: user.first_name
			last_name: user.last_name or { '' }
			birth_date: user.birth_date.str()
			email: user.email
		}
	})
}
