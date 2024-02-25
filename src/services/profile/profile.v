module profile

import contracts.contract_api { ContractApiNoContent, ContractApi }
import infra.repository.repository_profiles
import services.ws_context { Context }
import contracts.profile as cprofile
import x.vweb
import time

pub struct WsProfile {
	vweb.Middleware[Context]
}

@['/:short_uuid_profile/:name']
pub fn (ws &WsProfile) get_profile(mut ctx Context, short_uuid_profile string, name string) vweb.Result {
	profile_required := repository_profiles.get_profile_by_suuid(short_uuid_profile, name) or {
		ctx.res.set_status(.bad_request)
		return ctx.json(ContractApiNoContent{
			message: 'Perfil não encontrado'
			status: .error
		})
	}
	profile_pai := if profile_required.pai_id != none {
		if pai_id := profile_required.pai_id {
			repository_profiles.get_profiles_by_id(pai_id).first().adapter()
		} else {
			cprofile.Profile{}
		}
	} else {
		cprofile.Profile{}
	}

	profile_mae := if profile_required.mae_id != none {
		if mae_id := profile_required.mae_id {
			repository_profiles.get_profiles_by_id(mae_id).first().adapter()
		} else {
			cprofile.Profile{}
		}
	} else {
		cprofile.Profile{}
	}
	profile_irmaos := if profile_required.pai_id != none && profile_required.mae_id != none {
		pai_id := profile_required.pai_id
		mae_id := profile_required.mae_id
		if pai_id != none && mae_id != none {
			repository_profiles.get_profiles_irmaos(profile_required.id, pai_id, mae_id).map(it.adapter())
		} else {
			[]cprofile.Profile{}
		}
	} else {
		[]cprofile.Profile{}
	}

	profile := cprofile.Profile{
		uuid: profile_required.uuid
		apelido: profile_required.apelido
		primeiro_nome: profile_required.primeiro_nome
		segundo_nome: profile_required.segundo_nome
		idade: profile_required.idade
		peso: profile_required.peso
		sexo: profile_required.sexo
		altura: profile_required.altura
		cor: profile_required.cor
		data_nascimento: profile_required.data_nascimento or {
			time.date_from_days_after_unix_epoch(0)
		}
		pai: &profile_pai
		mae: &profile_mae
		irmaos: profile_irmaos
	}

	return ctx.json(ContractApi{
		message: ''
		status: .info
		content: profile
	})
}
