module profile

import contracts.contract_api { ContractApi, ContractApiNoContent }
import infra.profiles.repository.service as profile_service
import contracts.profile as cprofile
import api.ws_context
import constants
import x.vweb

pub struct WsProfile {
	vweb.Middleware[ws_context.Context]
}

@['/:short_uuid_profile/:name']
pub fn (ws &WsProfile) get_profile(mut ctx ws_context.Context, short_uuid_profile string, name string) vweb.Result {
	repo_profiles := profile_service.get()
	profile_required := repo_profiles.get_profile_by_suuid(short_uuid_profile, name) or {
		ctx.res.set_status(.bad_request)
		return ctx.json(ContractApiNoContent{
			message: 'Perfil não encontrado'
			status: .error
		})
	}
	mut profile_father := cprofile.ProfileAlias.new()
	if profile_required.father_id != none {
		if father_id := profile_required.father_id {
			profiles_ := repo_profiles.get_profiles_by_id(father_id)
			if profiles_.len > 0 {
				profile_father = profiles_.first().adapter()
			}
		}
	}

	mut profile_mother := cprofile.ProfileAlias.new()
	if profile_required.mother_id != none {
		if mother_id := profile_required.mother_id {
			profiles_ := repo_profiles.get_profiles_by_id(mother_id)
			if profiles_.len > 0 {
				profile_mother = profiles_.first().adapter()
			}
		}
	}

	mut profile_brothers := []cprofile.ProfileAlias{}
	if profile_required.father_id != none && profile_required.mother_id != none {
		father_id := profile_required.father_id
		mother_id := profile_required.mother_id
		if father_id != none && mother_id != none {
			profile_brothers = repo_profiles.get_profiles_irmaos(profile_required.id,
				father_id, mother_id).map(it.adapter())
		}
	}

	profile := cprofile.Profile{
		uuid: profile_required.uuid
		surname: profile_required.surname
		first_name: profile_required.first_name
		last_name: profile_required.last_name
		age: profile_required.age
		weight: profile_required.weight
		sex: profile_required.sex
		height: profile_required.height
		color: profile_required.color
		birth_date: profile_required.birth_date or { constants.time_empty }
		father: &profile_father
		mother: &profile_mother
		brothers: profile_brothers
	}

	return ctx.json(ContractApi{
		message: ''
		status: .info
		content: profile
	})
}
