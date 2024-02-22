module profile

import x.vweb
import services.ws_context { Context }
import infra.repository.repository_profiles
import contracts.profile as cprofile

pub struct WsProfile {
	vweb.Middleware[Context]
}

@['/:uuid_profile']
pub fn (ws &WsProfile) get_profile(mut ctx Context, uuid_profile string) vweb.Result {
	profile_required := repository_profiles.get_profile(uuid_profile)
	profile_pai := repository_profiles.get_profiles_by_id(profile_required.pai_id).first().adapter()
	profile_mae := repository_profiles.get_profiles_by_id(profile_required.mae_id).first().adapter()
	profile_irmaos := repository_profiles.get_profiles_irmaos(profile_required.id, profile_required.pai_id,
		profile_required.mae_id).map(it.adapter())

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
		data_nascimento: profile_required.data_nascimento
		pai: &profile_pai
		mae: &profile_mae
		irmaos: profile_irmaos
	}

	return ctx.json(profile)
}
