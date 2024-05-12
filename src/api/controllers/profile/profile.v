module profile

import contracts.contract_api { ContractApi, ContractApiNoContent }
import api.middleware.auth
import api.ws_context
import constants
import veb

@['/:short_uuid_profile/:name']
pub fn (ws &WsProfile) get_profile(mut ctx ws_context.Context, short_uuid_profile string, name string) veb.Result {
	profile := ws.hprofile_service.get_family_from_profile(short_uuid_profile, name) or {
		return ctx.json(ContractApiNoContent{
			message: 'Perfil não encontrado'
			status: .error
		})
	}

	return ctx.json(ContractApi{
		message: ''
		status: .info
		content: profile
	})
}

@['/details']
pub fn (ws &WsProfile) datails(mut ctx ws_context.Context) veb.Result {
	authorization := ctx.req.header.values(.authorization)[0] or { '' }.all_after_last(' ')

	user_uuid := auth.get_uuid_from_user(authorization) or {
		ctx.res.set_status(.not_found)
		return ctx.json(ContractApiNoContent{
			message: constants.msg_err_token_invalid
			status: .error
		})
	}

	profile := ws.hprofile_service.get_family(user_uuid) or {
		ctx.res.set_status(.not_found)
		return ctx.json(ContractApiNoContent{
			message: constants.msg_err_user_not_found
			status: .error
		})
	}

	return ctx.json(
		ContractApi{
			message: ''
			status: .info
			content: profile
		}
	)
}