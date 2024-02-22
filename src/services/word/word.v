module word

import contracts.contract_api { ContractApiNoContent }
import contracts.token { TokenJwtContract }
import infra.repository.repository_words
import ws_context { Context }
import infra.entities
import handle_jwt
import x.vweb

pub struct WsWord {
	vweb.Middleware[Context]
}

@['/']
pub fn (ws &WsWord) index(mut ctx Context) vweb.Result {
	access_token := ctx.req.header.values(.authorization)[0].after(' ')
	jwt_tok := handle_jwt.get[TokenJwtContract](access_token) or { return ctx.text('') }

	user_uuid := jwt_tok.payload.sub or {
		return ctx.json(ContractApiNoContent{
			message: 'Token inválido'
			status: .error
		})
	}

	return ctx.json(repository_words.get_all_by_id(entities.User{
		uuid: user_uuid
	}) or {
		return ctx.json(ContractApiNoContent{
			message: 'Não foi encontrado nenhuma palavra'
			status: .error
		})
	})
}
