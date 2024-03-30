module auth

import contracts.contract_api { ContractApi, ContractApiNoContent }
import infra.token.repository.service as token_service
import infra.jwt.repository.service as jwt_service
import infra.token.entities as token_entities
import contracts.token { TokenContract }
import api.ws_context
import constants
import x.vweb
import time
import rand

pub struct WsAuth {
	vweb.Middleware[ws_context.Context]
}

pub fn authenticate(mut ctx ws_context.Context) bool {
	authorization := ctx.req.header.values(.authorization)[0] or { '' }.all_after_last(' ')

	handle_jwt := jwt_service.get()

	if !handle_jwt.valid(authorization) {
		ctx.res.set_status(.unauthorized)
		ctx.json(ContractApiNoContent{
			message: 'Token expirou'
			status: .error
		})
		return false
	}

	return true
}

pub fn authenticate_recover_password(mut ctx ws_context.Context) bool {
	authorization := ctx.req.header.values(.authorization)[0] or { '' }.all_after_last(' ')

	handle_jwt := jwt_service.get()

	if !handle_jwt.valid(authorization) {
		ctx.res.set_status(.unauthorized)
		ctx.json(ContractApiNoContent{
			message: 'Token expirou'
			status: .error
		})
		return false
	}

	return true
}

@['/refresh-token']
pub fn (a &WsAuth) user_refresh_token(mut ctx ws_context.Context) vweb.Result {
	contract := TokenContract{
		refresh_token: ctx.req.header.custom_values('refresh-token')[0] or { '' }.after(' ')
		access_token: ctx.req.header.values(.authorization)[0] or { '' }.after(' ')
	}

	// TODO: Separar em uma função exclusiva para isso
	handle_jwt := jwt_service.get()
	payload := handle_jwt.payload(contract.access_token) or {
		ctx.res.set_status(.bad_request)
		return ctx.json(ContractApiNoContent{
			message: 'token inválido'
			status: .error
		})
	}

	origin_tok := token_entities.Token{
		user_uuid: payload.sub or { '' }
		access_token: contract.access_token
		refresh_token: contract.refresh_token
	}

	new_tok_jwt := handle_jwt.new_object_jwt(
		origin_tok.user_uuid,
		payload.ext.email,
		time.utc().add(time.hour * 5).str()
	) or {
		ctx.res.set_status(.unauthorized)
		return ctx.json(ContractApiNoContent{
			message: 'Token expirou'
			status: .error
		})
	}

	target_tok := token_entities.Token{
		user_uuid: payload.sub or { '' }
		access_token: new_tok_jwt.str()
		refresh_token: rand.uuid_v4()
		refresh_token_expiration: new_tok_jwt.payload.exp.time() or { time.utc() }.add_days(constants.day_expiration_refresh_token)
	}

	repos_tokens := token_service.get()
	repos_tokens.new_refresh_token(origin_tok, target_tok) or {
		ctx.res.set_status(.bad_request)
		return ctx.json(ContractApiNoContent{
			message: 'falhou a gerar um novo token'
			status: .error
		})
	}

	return ctx.json(ContractApi{
		message: 'Token gerado com sucesso'
		status: .info
		content: TokenContract{
			access_token: target_tok.access_token
			refresh_token: target_tok.refresh_token
		}
	})
}
