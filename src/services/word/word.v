module word

import infra.repository.repository_words.errors as repository_words_errors
import contracts.contract_api { ContractApi, ContractApiNoContent }
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

	words_ := repository_words.get_all_by_id(entities.User{
		uuid: user_uuid
	}) or {
		ctx.res.set_status(.bad_request)
		return ctx.json(ContractApiNoContent{
			message: 'Não foi encontrado nenhuma palavra'
			status: .error
		})
	}

	words := words_.map(cwords.WordContractResponse{
		id: it.id or { 0 }
		word: it.word
		translation: it.translation
		pronunciation: it.pronunciation
		audio: it.audio
	})

	return ctx.json(words)
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

	words_contract := json.decode(cwords.WordContractRequest, ctx.req.data) or {
		ctx.res.set_status(.bad_request)
		return ctx.json(ContractApiNoContent{
			message: 'O JSON fornecido não está de acordo com o contrato esperado.'
			status: .error
		})
	}

	words := words_contract.words.map(entities.Word{
		profile_uuid: words_contract.profile_uuid
		word: it.word
		translation: it.translation
		pronunciation: it.pronunciation
		audio: it.audio
	})

	if !words.all(it.valid()) {
		ctx.res.set_status(.unprocessable_entity)
		return ctx.json(ContractApi{
			// TODO: melhorar o texto
			message: 'Não foi possível inserir as seguintes palavras'
			status: .error
			content: words
		})
	}

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
