module user

import contracts.contract_api { ContractApi, ContractApiNoContent }
import contracts.token { TokenContractRecoverResponse }
import domain.user.contracts as cuser
import api.ws_context
import constants
import veb

const subject = '[DiBebê] Recuperação de senha'

@['/recover-password'; post]
pub fn (ws &WsUser) recover_password_send_email(mut ctx ws_context.Context) veb.Result {
	contract := cuser.ContractUser.adapter(ctx.req.data) or {
		ctx.res.set_status(.bad_request)
		return ctx.json(ContractApiNoContent{
			message: constants.msg_err_json_contract
			status:  .error
		})
	}

	access_tok := ws.huser_recovery_service.begin_recover_password(contract) or {
		ctx.res.set_status(.bad_request)
		return ctx.json(ContractApiNoContent{
			message: err.msg()
			status:  .error
		})
	}

	return ctx.json(ContractApi{
		message: constants.msg_send_email
		status:  .info
		content: TokenContractRecoverResponse{
			access_token: access_tok
		}
	})
}
