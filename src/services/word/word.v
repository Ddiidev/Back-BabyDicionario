module word

import contracts.contract_api { ContractApi, ContractApiNoContent }
import infra.repository.repository_words.errors as repository_words_errors
import infra.repository.repository_words
import services.ws_context { Context }
import contracts.words as cwords
import infra.entities
import services.auth
import x.vweb
import json

pub struct WsWord {
	vweb.Middleware[Context]
}

@['/']
pub fn (ws &WsWord) get(mut ctx Context) vweb.Result {
	access_token := ctx.req.header.values(.authorization)[0].after(' ')
	user_uuid := auth.get_uuid_from_user(access_token) or {
		ctx.res.set_status(.bad_request)
		return ctx.json(ContractApiNoContent{
			message: 'Token inválido'
			status: .error
		})
	}

	return ctx.json(repository_words.get_all_by_id(entities.User{
		uuid: user_uuid
	}) or {
		ctx.res.set_status(.bad_request)
		return ctx.json(ContractApiNoContent{
			message: 'Não foi encontrado nenhuma palavra'
			status: .error
		})
	})
}

@['/'; post]
pub fn (ws &WsWord) add(mut ctx Context) vweb.Result {
	access_token := ctx.req.header.values(.authorization)[0].after(' ')
	user_uuid := auth.get_uuid_from_user(access_token) or {
		ctx.res.set_status(.unprocessable_entity)
		return ctx.json(ContractApiNoContent{
			message: 'Token inválido'
			status: .error
		})
	}

	words_contract := json.decode([]cwords.WordContract, ctx.req.data) or {
		ctx.res.set_status(.bad_request)
		return ctx.json(ContractApiNoContent{
			message: 'O JSON fornecido não está de acordo com o contrato esperado.'
			status: .error
		})
	}

	words := words_contract.map(entities.Word{
		profile_uuid: it.profile_uuid
		palavra: it.palavra
		traducao: it.traducao
		pronuncia: it.pronuncia
		audio: it.audio
	})

	repository_words.new_words(entities.User{ uuid: user_uuid }, words) or {
		if err is repository_words_errors.WordsFailInsert {
			ctx.res.set_status(.unprocessable_entity)
			return ctx.json(ContractApi{
				// TODO: melhorar o texto
				message: 'Não foi possível inserir as seguintes palavras'
				status: .error
				content: err.words
			})
		} else {
			ctx.res.set_status(.unprocessable_entity)
			return ctx.json(ContractApiNoContent{
				// TODO: melhorar o texto
				message: 'Não foi possível inserir esta palavra'
				status: .error
			})
		}
	}

	return ctx.json(ContractApiNoContent{
		message: 'Palavras adicionadas com sucesso!'
		status: .info
	})
}
