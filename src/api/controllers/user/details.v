module user

import contracts.contract_api { ContractApi, ContractApiNoContent }
import domain.user.services as domain_user_services
import domain.user.contracts as cuser
import api.middleware.auth
import api.ws_context
import constants
import veb

@['/details']
pub fn (ws &WsUser) dails_user(mut ctx ws_context.Context) veb.Result {
	authorization := ctx.req.header.values(.authorization)[0] or { '' }.all_after_last(' ')

	huser_service := domain_user_services.get_user()

	user_uuid := auth.get_uuid_from_user(authorization) or {
		ctx.res.set_status(.not_found)
		return ctx.json(ContractApiNoContent{
			message: constants.msg_err_token_invalid
			status: .error
		})
	}

	user := huser_service.details(user_uuid) or {
		ctx.res.set_status(.bad_request)
		return ctx.json(ContractApiNoContent{
			message: err.msg()
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
