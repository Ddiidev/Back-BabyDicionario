module services

import constants
import domain.profile.models
import infra.profile.repository.service as infra_profile_service
import infra.profile.adapters as infra_profile_adapters

pub struct ProfileService {}

pub fn (p ProfileService) get_family_from_profile(short_uuid_profile string, name string) !models.Profile {
	repo_profile := infra_profile_service.get()

	profile_required := repo_profile.get_profile_by_suuid(short_uuid_profile, name)!

	mut profile_father := models.ProfileAlias.new()
	if profile_required.father_id != none {
		if father_id := profile_required.father_id {
			profiles_ := repo_profile.get_profiles_by_id(father_id)
			if profiles_.len > 0 {
				profile_father = infra_profile_adapters.adapter_word_entitie_to_model(profiles_.first())!
			}
		}
	}

	mut profile_mother := models.ProfileAlias.new()
	if profile_required.mother_id != none {
		if mother_id := profile_required.mother_id {
			profiles_ := repo_profile.get_profiles_by_id(mother_id)
			if profiles_.len > 0 {
				profile_mother = infra_profile_adapters.adapter_word_entitie_to_model(profiles_.first())!
			}
		}
	}

	mut profile_brothers := []models.ProfileAlias{}
	if profile_required.father_id != none && profile_required.mother_id != none {
		father_id := profile_required.father_id
		mother_id := profile_required.mother_id
		if father_id != none && mother_id != none {
			profile_brothers = repo_profile.get_profiles_brothers(profile_required.id,
				father_id, mother_id).map(models.ProfileAlias(infra_profile_adapters.adapter_word_entitie_to_model(it)!))
		}
	}

	return models.Profile.new(
		uuid: profile_required.uuid
		surname: profile_required.surname
		age: profile_required.age
		birth_date: profile_required.birth_date or { constants.time_empty }
		brothers: profile_brothers
		color: profile_required.color
		father: profile_father
		first_name: profile_required.first_name
		height: profile_required.height
		last_name: profile_required.last_name
		mother: profile_mother
		sex: profile_required.sex
		weight: profile_required.weight
	)
}
