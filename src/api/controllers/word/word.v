module word

import contracts.contract_api { ContractApi, ContractApiNoContent }
import infra.word.repository.errors as infra_word_errors
import domain.word.errors as domain_word_errors
import domain.word.models
import api.ws_context
import constants
import veb
import json

@['/:profile_uuid/count'; get]
pub fn (ws &WsWord) count_words(mut ctx ws_context.Context, profile_uuid string) veb.Result {
	if profile_uuid == '' {
		ctx.res.set_status(.bad_request)
		return ctx.json(ContractApiNoContent{
			message: constants.msg_err_profile_not_found
			status:  .error
		})
	}

	count := ws.hword_service.count_words(profile_uuid) or {
		ctx.res.set_status(.bad_request)
		return ctx.json(ContractApiNoContent{
			message: err.msg()
			status:  .error
		})
	}

	return ctx.json(ContractApi{
		message: 'Contagem de palavras realizada com s ucesso!'
		status:  .info
		content: count
	})
}

@['/:short_uuid/:name_profile']
pub fn (ws &WsWord) get(mut ctx ws_context.Context, short_uuid string, name_profile string) veb.Result {
	words := ws.hword_service.get_all_by_uuid(short_uuid, name_profile)

	return ctx.json(ContractApi{
		message: 'Palavras recuperadas com sucesso!'
		status:  .info
		content: words
	})
}

@['/:short_uuid/:name_profile'; post]
pub fn (ws &WsWord) save_words(mut ctx ws_context.Context, short_uuid string, name_profile string) veb.Result {
	if short_uuid == '' || name_profile == '' {
		ctx.res.set_status(.bad_request)
		return ctx.json(ContractApiNoContent{
			message: constants.msg_err_profile_not_found
			status:  .error
		})
	}

	words_contract := json.decode([]models.Word, ctx.req.data) or {
		ctx.res.set_status(.bad_request)
		return ctx.json(ContractApiNoContent{
			message: constants.msg_err_json_contract
			status:  .error
		})
	}

	words_created := ws.hword_service.save_words(short_uuid, name_profile, words_contract) or {
		match err {
			domain_word_errors.WordsErrorInvalid {
				return ctx.json(ContractApi{
					message: err.msg()
					status:  .error
					content: err.words_fail
				})
			}
			infra_word_errors.WordsFailInsert {
				return ctx.json(ContractApi{
					message: err.msg()
					status:  .error
					content: err.word
				})
			}
			else {
				return ctx.json(ContractApiNoContent{
					message: err.msg()
					status:  .error
				})
			}
		}
	}

	return ctx.json(ContractApi{
		message: 'Palavras adicionadas com sucesso!'
		status:  .info
		content: words_created
	})
}

@['/:word_uuid'; delete]
pub fn (ws &WsWord) delete_words(mut ctx ws_context.Context, word_uuid string) veb.Result {
	if word_uuid == '' {
		ctx.res.set_status(.bad_request)
		return ctx.json(ContractApiNoContent{
			message: constants.msg_err_profile_not_found
			status:  .error
		})
	}

	ws.hword_service.delete_words(word_uuid) or {
		return ctx.json(ContractApiNoContent{
			message: err.msg()
			status:  .error
		})
	}

	return ctx.json(ContractApiNoContent{
		message: 'Palavra deletada com sucesso!'
		status:  .info
	})
}
