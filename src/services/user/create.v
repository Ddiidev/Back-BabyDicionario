module user

import contracts.contract_api { ContractApiNoContent }
import infra.repository.repository_users
import contracts.user { ContractEmail }
import services.ws_context { Context }
import infra.entities
import services.email
import x.vweb
import json
import rand

@['/create/send-code'; post]
pub fn (ws &WsUser) send_confirmation_email(mut ctx Context) vweb.Result {
	contract := json.decode(ContractEmail, ctx.req.data) or {
		ctx.res.set_status(.unprocessable_entity)
		return ctx.json(ContractApiNoContent{
			message: 'O JSON fornecido não está de acordo com o contrato esperado.'
			status: .error
		})
	}

	if repository_users.contain_user_with_email(contract.email) {
		ctx.res.set_status(.conflict)
		return ctx.json(ContractApiNoContent{
			message: 'Este email já foi registrado no Dicionário do bebê.\n\nPrefira fazer o login ao invés de nova conta (E pode preencher o formulário de senha esquecida caso necessário).'
			status: .error
		})
	}

	user_temp_exist := repository_users.get_user_temp_existing(contract.email)
	code_confirmation := if user_temp_exist != none {
		user_temp_exist.code_confirmation
	} else {
		rand.i64_in_range(111111, 999999) or { rand.int63() }.str().limit(6)
	}

	body := body_msg_confirmation_html(contract.first_name, code_confirmation)

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

		user_temp := entities.UserTemp{
			primeiro_nome: contract.first_name
			responsavel: contract.responsible
			data_nascimento: contract_data_nascimento
			email: contract.email
			senha: contract.password
		}

		repository_users.new_user_confirmation(user_temp, code_confirmation) or {
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
