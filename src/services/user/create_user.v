module user

import contracts.contract_api { ContractApiNoContent }
import services.ws_context { Context }
import contracts.confirmation { ContractEmail }
import infra.repository.repository_users
import services.email
import infra.entities
import vdapter
import x.vweb
import json
import rand

pub struct WsUser {
	vweb.Middleware[Context]
}

@['/create-user/send-code-confirmation'; post]
pub fn (ws &WsUser) send_confirmation_email(mut ctx Context) vweb.Result {
	contract := json.decode(ContractEmail, ctx.req.data) or {
		ctx.res.set_status(.bad_request)
		return ctx.json(ContractApiNoContent{
			message: 'O JSON fornecido não está de acordo com o contrato esperado.'
			status: .error
		})
	}

	code_confirmation := rand.i64_in_range(111111, 999999) or { rand.int63() }.str().limit(6)

	body := body_msg_confirmation_html(contract.primeiro_nome, code_confirmation)

	email.send(contract.email, '[DiBebê] Ative sua conta de usuário ${contract.primeiro_nome}',
		body) or {
		ctx.res.set_status(.bad_request)
		return ctx.json(ContractApiNoContent{
			message: 'Falha ao enviar o email de confirmação, verificar se o email está correto'
			status: .error
		})
	}

	user_temp := vdapter.adapter[entities.UserTemp](contract)

	repository_users.new_user_confirmation(user_temp, code_confirmation) or {
		ctx.res.set_status(.bad_request)
		return ctx.json(ContractApiNoContent{
			message: 'Falha ao cadastrar no banco o usuário'
			status: .error
		})
	}

	return ctx.json(ContractApiNoContent{
		message: 'Email enviado com sucesso'
		status: .info
	})
}