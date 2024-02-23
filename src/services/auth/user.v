module auth

import contracts.contract_api { ContractApi, ContractApiNoContent }
import contracts.token { TokenContract, TokenJwtContract }
import infra.repository.repository_tokens
import services.ws_context { Context }
import contracts.confirmation
import services.handle_jwt
import infra.entities
import constants
import vdapter
import x.vweb
import time
import rand
import jwt

pub struct WsAuth {
	vweb.Middleware[Context]
}

pub fn authenticate(mut ctx Context) bool {
	authorization := ctx.req.header.values(.authorization)[0] or { '' }

	tok_jwt := handle_jwt.get[confirmation.ConfirmationEmail](authorization) or { return false }

	if tok_jwt.valid($env('BABYDI_SECRETKEY')) || tok_jwt.expired() {
		ctx.res.set_status(.unauthorized)
		ctx.json(ContractApiNoContent{
			message: 'Token expirou'
			status: .error
		})
		return false
	}

	return true
}

@['/refresh_token']
pub fn (a &WsAuth) user_refresh_token(mut ctx Context) vweb.Result {
	contract := TokenContract{
		refresh_token: ctx.req.header.custom_values('refresh_token')[0] or { '' }.after(' ')
		access_token: ctx.req.header.values(.authorization)[0] or { '' }.after(' ')
	}

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
		time.utc().str())

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
		content: vdapter.adapter_wip[entities.Token, TokenContract](target_tok)
	})
}
