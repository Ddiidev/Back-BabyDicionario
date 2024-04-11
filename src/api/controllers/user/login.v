module user

import contracts.contract_api { ContractApi, ContractApiNoContent }
import domain.user.contracts
import api.ws_context
import constants
import x.vweb
import domain.user.errors

@['/login'; post]
pub fn (ws &WsUser) login(mut ctx ws_context.Context) vweb.Result {
	contract := contracts.ContractEmail.adapter(ctx.req.data) or {
		ctx.res.set_status(.unprocessable_entity)
		return ctx.json(ContractApiNoContent{
			message: constants.msg_err_json_contract
			status: .error
		})
	}

	token_resp_contrat := ws.huser_service.login(contract.email, contract.password) or {
		match err {
			errors.UserErrorEmailOrPasswodInvaild {
				ctx.res.set_status(.not_found)
			}
			errors.UserErrorUserBlockedInvaild {
				ctx.res.set_status(.unauthorized)
			}
			else {
				ctx.res.set_status(.bad_request)
			}
		}

		return ctx.json(ContractApiNoContent{
			message: err.msg()
			status: .error
		})
	}

	return ctx.json(ContractApi{
		message: 'Login concluído'
		status: .info
		content: token_resp_contrat
	})
}
