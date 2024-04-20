module word

import contracts.contract_api { ContractApi, ContractApiNoContent }
import infra.word.repository.errors as infra_word_errors
import domain.word.errors as domain_word_errors
import domain.word.models
import api.ws_context
import x.vweb
import json

@['/']
pub fn (ws &WsWord) get(mut ctx ws_context.Context) vweb.Result {
	profile_uuid := ctx.req.header.get_custom('profile_uuid') or { '' }

	words := ws.hword_service.get_all_by_uuid(profile_uuid)

	return ctx.json(words)
}

@['/'; post]
pub fn (ws &WsWord) add(mut ctx ws_context.Context) vweb.Result {
	profile_uuid := ctx.req.header.get_custom('profile_uuid') or { '' }

	words_contract := json.decode([]models.Word, ctx.req.data) or {
		ctx.res.set_status(.bad_request)
		return ctx.json(ContractApiNoContent{
			message: 'O JSON fornecido não está de acordo com o contrato esperado.'
			status: .error
		})
	}

	ws.hword_service.new_words(profile_uuid, words_contract) or {
		match err {
			domain_word_errors.WordsErrorInvalid {
				return ctx.json(ContractApi{
					message: err.msg()
					status: .error
					content: err.words_fail
				})
			}
			infra_word_errors.WordsFailInsert {
				return ctx.json(ContractApi{
					message: err.msg()
					status: .error
					content: err.words
				})
			}
			else {
				return ctx.json(ContractApiNoContent{
					message: err.msg()
					status: .error
				})
			}
		}
	}

	return ctx.json(ContractApiNoContent{
		message: 'Palavras adicionadas com sucesso!'
		status: .info
	})
}
