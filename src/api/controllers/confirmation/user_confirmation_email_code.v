module confirmation

import contracts.contract_api { ContractApi, ContractApiNoContent }
import contracts.token { TokenContract }
import api.ws_context
import x.vweb


import domain.email.contracts as email_contract
import domain.email.application_service

@['/'; post]
pub fn (ws &WsConfirmation) confirmation_email_code_user(mut ctx ws_context.Context) vweb.Result {
	contract := email_contract.ConfirmationEmailByCode.adapter(ctx.req.data)  or {
		ctx.res.set_status(.unprocessable_entity)
		return ctx.json(ContractApiNoContent{
			message: 'O JSON fornecido não está de acordo com o contrato esperado.'
			status: .error
		})
	}

	token_model := application_service.confirm_email_by_code(contract) or {
		ctx.res.set_status(.bad_request)

		return ctx.json(ContractApiNoContent{
			message: err.msg()
			status: .error
		})
	}

	return ctx.json(ContractApi{
		message: 'Usuário confirmado!'
		status: .info
		content: TokenContract{
			access_token: token_model.access_token
			refresh_token: token_model.refresh_token
		}
	})
	// repo_users_confirmation := user_service.get_user_confirmation()
	// user_temp := repo_users_confirmation.get_user(contract.email, contract.code) or {
	// 	ctx.res.set_status(.bad_request)

	// 	if err in [users_error.InvalidCode, users_error.NoExistUserTemp] {
	// 		return ctx.json(ContractApiNoContent{
	// 			message: err.msg()
	// 			status: .error
	// 		})
	// 	}

	// 	return ctx.json(ContractApiNoContent{
	// 		message: 'Falha ao consultar o banco'
	// 		status: .error
	// 	})
	// }

	// if user_temp.is_valid() {
	// 	user := repo_users_confirmation.create_user_valid(user_temp) or {
	// 		dump(err)
	// 		ctx.res.set_status(.bad_request)
	// 		return ctx.json(ContractApiNoContent{
	// 			message: 'Falha ao acessar o usuário'
	// 			status: .error
	// 		})
	// 	}

	// 	handle_jwt := jwt_service.get()
	// 	jwt_tok := handle_jwt.new_jwt(user.uuid, user.email, user_temp.expiration_time.str())

	// 	mut tok := token_entities.Token{
	// 		user_uuid: user.uuid
	// 		access_token: jwt_tok.str()
	// 		refresh_token: rand.uuid_v4()
	// 	}

	// 	repo_tokens := token_service.get()
	// 	repo_tokens.create(tok) or {
	// 		if err is TokenNoExist {
	// 			ctx.res.set_status(.bad_request)
	// 			return ctx.json(ContractApiNoContent{
	// 				message: 'Falha ao criar um token de acesso\nEntre em contato conosco por email'
	// 				status: .error
	// 			})
	// 		} else {
	// 			tok = repo_tokens.get_by_uuid(tok) or {
	// 				ctx.res.set_status(.bad_request)
	// 				return ctx.json(ContractApiNoContent{
	// 					message: 'Falha ao obter o token de acesso\nEntre em contato conosco por email'
	// 					status: .error
	// 				})
	// 			}
	// 		}
	// 	}

	// 	repo_users := user_service.get()
	// 	if repo_users.contain_user_with_uuid(user.uuid) {
	// 		repo_users_confirmation.delete(user_temp) or {
	// 			// add log
	// 		}
	// 	}

	// 	defer {
	// 		email := email_service.get()
	// 		email.send(user_temp.email, '[DiBebê] Grato por estar aqui', body_msg_congratulations_html(user.first_name)) or {
	// 			println(err) // TODO add log
	// 		}
	// 	}
	// } else {
	// 	ctx.res.set_status(.bad_request)
	// 	return ctx.json(ContractApiNoContent{
	// 		message: 'O código de ativação expirou!\nVocê pode iniciar um novo cadastro para obter um novo código de ativação.'
	// 		status: .error
	// 	})
	// }
}
