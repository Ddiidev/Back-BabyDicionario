module profile

import contracts.contract_api { ContractApi, ContractApiNoContent }
import api.ws_context
import x.vweb

// vfmt off
@['/:short_uuid_profile/:name']
pub fn (ws (&WsProfile)) get_profile(mut ctx ws_context.Context, short_uuid_profile string, name string) vweb.Result {
	// vfmt on
	profile := ws.hprofile_service.get_family_from_profile(short_uuid_profile, name) or {
		return ctx.json(ContractApiNoContent{
			message: 'Perfil não encontrado'
			status: .error
		})
	}

	return ctx.json(ContractApi{
		message: ''
		status: .info
		content: profile
	})
}
