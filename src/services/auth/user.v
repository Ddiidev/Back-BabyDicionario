module auth

import contracts.contract_api { ContractApi, ContractApiNoContent }
import contracts.token { TokenContract, TokenJwtContract }
import infra.repository.repository_tokens
import services.ws_context { Context }
import services.handle_jwt
import infra.entities
import constants
import x.vweb
import time
import rand
import jwt

pub struct WsAuth {
	vweb.Middleware[Context]
}

pub fn authenticate(mut ctx Context) bool {
	authorization := ctx.req.header.values(.authorization)[0] or { '' }.all_after_last(' ')

	tok_jwt := handle_jwt.get(authorization) or {
		ctx.res.set_status(.unauthorized)
		ctx.json(ContractApiNoContent{
			message: 'Token expirou'
			status: .error
		})
		return false
	}

	if !tok_jwt.valid($env('BABYDI_SECRETKEY')) {
		ctx.res.set_status(.unauthorized)
		ctx.json(ContractApiNoContent{
			message: 'Token expirou'
			status: .error
		})
		return false
	}

	return true
}

pub fn authenticate_recover_password(mut ctx Context) bool {
	authorization := ctx.req.header.values(.authorization)[0] or { '' }.all_after_last(' ')

	tok_jwt := handle_jwt.get(authorization) or {
		ctx.res.set_status(.unauthorized)
		ctx.json(ContractApiNoContent{
			message: 'Token expirou'
			status: .error
		})
		return false
	}

	if !tok_jwt.valid($env('BABYDI_SECRETKEY')) {
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
pub fn (a &WsAuth) user_refresh_token(mut ctx Context) vweb.Result {
	contract := TokenContract{
		refresh_token: ctx.req.header.custom_values('refresh-token')[0] or { '' }.after(' ')
		access_token: ctx.req.header.values(.authorization)[0] or { '' }.after(' ')
	}

	// TODO: Separar em uma função exclusiva para isso
	tok_jwt := jwt.from_str[TokenJwtContract](contract.access_token) or {
		ctx.res.set_status(.bad_request)
		return ctx.json(ContractApiNoContent{
			message: 'token inválido'
			status: .error
		})
	}

	origin_tok := entities.Token{
		user_uuid: tok_jwt.payload.sub or { '' }
		access_token: contract.access_token
		refresh_token: contract.refresh_token
	}

	new_tok_jwt := handle_jwt.new_jwt(origin_tok.user_uuid, tok_jwt.payload.ext.email,
		time.utc().add(time.hour * 5).str())

	target_tok := entities.Token{
		user_uuid: tok_jwt.payload.sub or { '' }
		access_token: new_tok_jwt.str()
		refresh_token: rand.uuid_v4()
		refresh_token_expiration: new_tok_jwt.payload.exp.time() or { time.utc() }.add_days(constants.day_expiration_refresh_token)
	}

	repository_tokens.new_refresh_token(origin_tok, target_tok) or {
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
