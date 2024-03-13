module confirmation

import contracts.contract_api { ContractApi, ContractApiNoContent }
import infra.repository.repository_tokens.errors { TokenNoExist }
import infra.repository.repository_users.errors as users_error
import contracts.confirmation { ConfirmationEmailByCode }
import infra.repository.repository_tokens
import infra.repository.repository_users
import contracts.token { TokenContract }
import services.ws_context { Context }
import services.handle_jwt
import infra.entities
import services.email
import x.vweb
import rand
import json

@['/'; post]
pub fn (ws &WsConfirmation) confirmation_email_code_user(mut ctx Context) vweb.Result {
	contract := json.decode(ConfirmationEmailByCode, ctx.req.data) or {
		ctx.res.set_status(.unprocessable_entity)
		return ctx.json(ContractApiNoContent{
			message: 'O JSON fornecido não está de acordo com o contrato esperado.'
			status: .error
		})
	}

	user_temp := repository_users.get_user_temp_confirmation(contract.email, contract.code) or {
		ctx.res.set_status(.bad_request)

		if err in [users_error.InvalidCode, users_error.NoExistUserTemp] {
			return ctx.json(ContractApiNoContent{
				message: err.msg()
				status: .error
			})
		}

		return ctx.json(ContractApiNoContent{
			message: 'Falha ao consultar o banco'
			status: .error
		})
	}

	if user_temp.is_valid() {
		user := repository_users.create_user_valid(user_temp) or {
			ctx.res.set_status(.bad_request)
			return ctx.json(ContractApiNoContent{
				message: 'Falha ao acessar o usuário'
				status: .error
			})
		}

		jwt_tok := handle_jwt.new_jwt(user.uuid, user.email, user_temp.expiration_time.str())

		mut tok := entities.Token{
			user_uuid: user.uuid
			access_token: jwt_tok.str()
			refresh_token: rand.uuid_v4()
		}

		repository_tokens.create_token(tok) or {
			if err is TokenNoExist {
				ctx.res.set_status(.bad_request)
				return ctx.json(ContractApiNoContent{
					message: 'Falha ao criar um token de acesso\nEntre em contato conosco por email'
					status: .error
				})
			} else {
				tok = repository_tokens.get_by_uuid(tok) or {
					ctx.res.set_status(.bad_request)
					return ctx.json(ContractApiNoContent{
						message: 'Falha ao obter o token de acesso\nEntre em contato conosco por email'
						status: .error
					})
				}
			}
		}

		if repository_users.contain_user_with_uuid(user.uuid) {
			repository_users.delete_usertemp(user_temp) or {
				// add log
			}
		}

		defer {
			email.send(user_temp.email, '[DiBebê] Grato por estar aqui', body_msg_congratulations_html(user.primeiro_nome)) or {
				println(err) // TODO add log
			}
		}

		return ctx.json(ContractApi{
			message: 'Usuário verificado com sucesso!'
			status: .info
			content: TokenContract{
				access_token: tok.access_token
				refresh_token: tok.refresh_token
			}
		})
	} else {
		ctx.res.set_status(.bad_request)
		return ctx.json(ContractApiNoContent{
			message: 'O código de ativação expirou!\nVocê pode iniciar um novo cadastro para obter um novo código de ativação.'
			status: .error
		})
	}

	ctx.res.set_status(.bad_request)
	return ctx.json(ContractApi[[]entities.UserTemp]{
		message: 'Falha ao consultar o banco'
		status: .error
	})
}
