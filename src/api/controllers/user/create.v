module user

import contracts.contract_api { ContractApiNoContent }
import infra.email.repository.service as email_service
import infra.user.repository.service as user_service
import infra.user.entities as user_entites
import contracts.user { ContractEmail }
import api.ws_context
import utils.auth
import x.vweb
import json

@['/create/send-code'; post]
pub fn (ws &WsUser) send_confirmation_email(mut ctx ws_context.Context) vweb.Result {
	contract := json.decode(ContractEmail, ctx.req.data) or {
		ctx.res.set_status(.unprocessable_entity)
		return ctx.json(ContractApiNoContent{
			message: 'O JSON fornecido não está de acordo com o contrato esperado.'
			status: .error
		})
	}

	repo_users := user_service.get()
	if repo_users.contain_user_with_email(contract.email) {
		ctx.res.set_status(.conflict)
		return ctx.json(ContractApiNoContent{
			message: 'Este email já foi registrado no Dicionário do bebê.\n\nPrefira fazer o login ao invés de nova conta (E pode preencher o formulário de senha esquecida caso necessário).'
			status: .error
		})
	}

	repo_users_confirmation := user_service.get_user_confirmatino()
	user_temp_exist := repo_users_confirmation.get_user_existing(contract.email)
	code_confirmation := if user_temp_exist != none {
		user_temp_exist.code_confirmation
	} else {
		auth.random_number()
	}

	body := body_msg_confirmation_html(contract.first_name, code_confirmation)

	email := email_service.get()

	email.send(contract.email, '[DiBebê] Ative sua conta de usuário ${contract.first_name}',
		body) or {
		ctx.res.set_status(.bad_request)
		return ctx.json(ContractApiNoContent{
			message: 'Falha ao enviar o email de confirmação, verificar se o email está correto'
			status: .error
		})
	}

	if user_temp_exist == none {
		contract_data_nascimento := contract.birth_date.time() or {
			ctx.res.set_status(.bad_request)
			return ctx.json(ContractApiNoContent{
				message: 'Formato da data de nascimento está inválido'
				status: .error
			})
		}

		user_temp := user_entites.UserTemp{
			first_name: contract.first_name
			responsible: contract.responsible
			birth_date: contract_data_nascimento
			email: contract.email
			password: contract.password
		}

		repo_users_confirmation.new_user_confirmation(user_temp, code_confirmation) or {
			ctx.res.set_status(.bad_request)
			return ctx.json(ContractApiNoContent{
				message: 'Falha ao cadastrar no banco o usuário'
				status: .error
			})
		}
	}

	return ctx.json(ContractApiNoContent{
		message: 'Email enviado com sucesso'
		status: .info
	})
}
