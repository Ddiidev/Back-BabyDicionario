module user

import infra.repository.repository_users
import contracts.contract_api { ContractApiNoContent, ContractApi }
import services.ws_context { Context }
import infra.entities
import services.auth
import constants
import x.vweb

@['/dails']
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
		message: constants.msg_err_user_found
		status: .error
		content: user
	})
}