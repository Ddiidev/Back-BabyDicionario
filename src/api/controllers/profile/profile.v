module profile

import contracts.contract_api { ContractApi, ContractApiNoContent }
import domain.profile.application_service as app_service_profile
import infra.storage_babydi.repository.service as storage_service
import domain.profile.contracts
import api.middleware.auth
import api.ws_context
import constants
import veb

@['/contain/:uuid']
fn (ws &WsProfile) contain(mut ctx ws_context.Context, uuid string) veb.Result {
	if !ws.hprofile_service.contain(uuid) {
		ctx.res.set_status(.not_found)
		ctx.json({
			'message': 'Perfil não encontrado.'
			'status':  'error'
		})
	}

	return ctx.json({
		'message': 'OK'
		'status':  'info'
	})
}

@['/default-from-user/:user_uuid'; get]
pub fn (ws &WsProfile) default_from_user(mut ctx ws_context.Context, user_uuid string) veb.Result {
	profile := ws.hprofile_service.get_default_uuid_from_user(user_uuid) or {
		ctx.res.set_status(.not_found)
		return ctx.json(ContractApiNoContent{
			message: constants.msg_err_profile_not_found
			status:  .error
		})
	}

	return ctx.json(ContractApi{
		message: ''
		status:  .info
		content: profile
	})
}

@['/all-family']
pub fn (ws &WsProfile) get_profile_all_family(mut ctx ws_context.Context) veb.Result {
	authorization := ctx.req.header.values(.authorization)[0] or { '' }.all_after_last(' ')

	user_uuid := auth.get_uuid_from_user(authorization) or {
		ctx.res.set_status(.not_found)
		return ctx.json(ContractApiNoContent{
			message: constants.msg_err_token_invalid
			status:  .error
		})
	}

	profile := ws.hprofile_service.get_family_profiles(user_uuid) or {
		return ctx.json(ContractApiNoContent{
			message: 'Perfil não encontrado'
			status:  .error
		})
	}

	return ctx.json(ContractApi{
		message: ''
		status:  .info
		content: profile
	})
}

@['/:short_uuid_profile/:name']
pub fn (ws &WsProfile) get(mut ctx ws_context.Context, short_uuid_profile string, name string) veb.Result {
	profile := ws.hprofile_service.get(short_uuid_profile, name) or {
		return ctx.json(ContractApiNoContent{
			message: 'Perfil não encontrado'
			status:  .error
		})
	}

	return ctx.json(ContractApi{
		message: ''
		status:  .info
		content: profile
	})
}

@['/details-home']
pub fn (ws &WsProfile) datails_home(mut ctx ws_context.Context) veb.Result {
	authorization := ctx.req.header.values(.authorization)[0] or { '' }.all_after_last(' ')

	user_uuid := auth.get_uuid_from_user(authorization) or {
		ctx.res.set_status(.not_found)
		return ctx.json(ContractApiNoContent{
			message: constants.msg_err_token_invalid
			status:  .error
		})
	}

	profile := ws.hprofile_service.get_family(user_uuid) or {
		ctx.res.set_status(.not_found)
		return ctx.json(ContractApiNoContent{
			message: constants.msg_err_user_not_found
			status:  .error
		})
	}

	return ctx.json(ContractApi{
		message: ''
		status:  .info
		content: profile
	})
}

@['/'; put]
pub fn (ws &WsProfile) update(mut ctx ws_context.Context) veb.Result {
	profile := contracts.ContractProfile.adapter(ctx.req.data) or {
		ctx.res.set_status(.unprocessable_entity)
		return ctx.json(ContractApiNoContent{
			message: constants.msg_err_json_contract
			status:  .error
		})
	}

	ws.hprofile_service.update(profile) or {
		ctx.res.set_status(.not_found)
		return ctx.json(ContractApiNoContent{
			message: constants.msg_err_user_not_found
			status:  .error
		})
	}

	return ctx.json(ContractApiNoContent{
		message: 'Perfil atualizado com sucesso'
		status:  .info
	})
}

@['/'; post]
pub fn (ws &WsProfile) create(mut ctx ws_context.Context) veb.Result {
	authorization := ctx.req.header.values(.authorization)[0] or { '' }.all_after_last(' ')

	user_uuid := auth.get_uuid_from_user(authorization) or {
		ctx.res.set_status(.not_found)
		return ctx.json(ContractApiNoContent{
			message: constants.msg_err_token_invalid
			status:  .error
		})
	}

	profile := contracts.ContractProfile.adapter(ctx.req.data) or {
		ctx.res.set_status(.unprocessable_entity)
		return ctx.json(ContractApiNoContent{
			message: constants.msg_err_json_contract
			status:  .error
		})
	}

	profile_created := app_service_profile.create_profile(profile, user_uuid) or {
		ctx.res.set_status(.not_found)
		return ctx.json(ContractApiNoContent{
			message: err.msg()
			status:  .error
		})
	}

	return ctx.json(ContractApi{
		message: 'Perfil inserido com sucesso'
		status:  .info
		content: profile_created
	})
}

@['/:uuid_profile'; delete]
pub fn (ws &WsProfile) disabled(mut ctx ws_context.Context, uuid_profile string) veb.Result {
	authorization := ctx.req.header.values(.authorization)[0] or { '' }.all_after_last(' ')

	user_uuid := auth.get_uuid_from_user(authorization) or {
		ctx.res.set_status(.not_found)
		return ctx.json(ContractApiNoContent{
			message: constants.msg_err_user_not_found
			status:  .error
		})
	}
	ws.hprofile_service.disabled(uuid_profile) or {
		ctx.res.set_status(.not_found)
		return ctx.json(ContractApiNoContent{
			message: constants.msg_err_user_not_found
			status:  .error
		})
	}

	hstorage_service := storage_service.get()

	hstorage_service.delete_profile(user_uuid, uuid_profile) or {}

	return ctx.json(ContractApiNoContent{
		message: 'Perfil excluído com sucesso'
		status:  .info
	})
}
