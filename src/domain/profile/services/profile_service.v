module services

import infra.profile.repository.service as infra_profile_service
import infra.family.repository.service as infra_family_service
import infra.profile.adapters as infra_profile_adapters
import infra.family.adapters as infra_family_adapters
import infra.profile.entities
import domain.profile.models
import domain.types
import constants

pub struct ProfileService {}

fn (p ProfileService) create(profile models.Profile) !models.Profile {
	repo_profile := infra_profile_service.get()
	repo_profile.create(infra_profile_adapters.model_to_entitie(profile)!)!

	return infra_profile_adapters.entitie_to_model(repo_profile.get_profile(profile.uuid) or {
		return error('Perfil não existe')
	})
}

pub fn (p ProfileService) update(profile models.Profile) ! {
	repo_profile := infra_profile_service.get()

	repo_profile.update(infra_profile_adapters.model_to_entitie(profile)!)!
}

pub fn (p ProfileService) update_family_id(uuid string, family_id int) ! {
	repo_profile := infra_profile_service.get()

	repo_profile.update_family_id(uuid, family_id)!
}

pub fn (p ProfileService) get_family_from_profile(short_uuid_profile string, name string) !models.Profile {
	repo_profile := infra_profile_service.get()
	repo_family := infra_family_service.get()

	profile_required := repo_profile.get_profile_by_suuid(short_uuid_profile, name)!

	if resp_temp := types.Responsible.from_i8(profile_required.responsible) {
		if resp_temp in [.pai, .mae] {
			return models.Profile.new_return(
				uuid:             profile_required.uuid
				surname:          profile_required.surname
				name_shared_link: profile_required.name_shared_link
				age:              profile_required.age
				birth_date:       profile_required.birth_date or { constants.time_empty }
				color:            profile_required.color
				first_name:       profile_required.first_name
				height:           profile_required.height
				last_name:        profile_required.last_name
				sex:              types.Sex.from_i8(profile_required.sex)
				weight:           profile_required.weight
			)
		}
	}

	family := repo_family.get_by_id(profile_required.family_id)!

	mut profile_father := models.ProfileAlias.new()
	if father_uuid := family.profile_uuid_father {
		profile_father = infra_profile_adapters.entitie_to_model(repo_profile.get_profile(father_uuid) or {
			entities.Profile{}
		})!
	}

	mut profile_mother := models.ProfileAlias.new()
	if mother_uuid := family.profile_uuid_mother {
		profile_mother = infra_profile_adapters.entitie_to_model(repo_profile.get_profile(mother_uuid) or {
			entities.Profile{}
		})!
	}

	mut profile_brothers := []models.ProfileAlias{}
	if family.profile_uuid_father != none && family.profile_uuid_mother != none {
		father_uuid := family.profile_uuid_father
		mother_uuid := family.profile_uuid_mother
		if father_uuid != none && mother_uuid != none {
			profile_brothers = repo_profile.get_profiles_brothers(profile_required.id,
				family.id or { -1 }).map(models.ProfileAlias(infra_profile_adapters.entitie_to_model(it)!))
		}
	}

	return models.Profile.new_return(
		uuid:       profile_required.uuid
		surname:    profile_required.surname
		age:        profile_required.age
		birth_date: profile_required.birth_date or { constants.time_empty }
		brothers:   profile_brothers
		color:      profile_required.color
		father:     profile_father
		first_name: profile_required.first_name
		height:     profile_required.height
		last_name:  profile_required.last_name
		mother:     profile_mother
		sex:        types.Sex.from_i8(profile_required.sex)
		weight:     profile_required.weight
	)
}

pub fn (p ProfileService) get(short_uuid_profile string, name string) !models.Profile {
	repo_profile := infra_profile_service.get()

	profile_required := repo_profile.get_profile_by_suuid(short_uuid_profile, name)!

	return models.Profile.new_return(
		uuid:             profile_required.uuid
		surname:          profile_required.surname
		age:              profile_required.age
		name_shared_link: profile_required.name_shared_link
		birth_date:       profile_required.birth_date or { constants.time_empty }
		color:            profile_required.color
		first_name:       profile_required.first_name
		height:           profile_required.height
		last_name:        profile_required.last_name
		sex:              types.Sex.from_i8(profile_required.sex)
		weight:           profile_required.weight
	)
}

pub fn (p ProfileService) get_family(user_uuid string) !models.Profile {
	repo_profile := infra_profile_service.get()
	repo_family := infra_family_service.get()

	family := repo_family.get_by_user(user_uuid)!

	_, uuid_profile := family.get_uuid_user_and_profile()
	profile_required := repo_profile.get_profile(uuid_profile or { '' }) or {
		return error('Perfil não existe')
	}

	mut profile_father := models.ProfileAlias.new()
	if father_uuid := family.profile_uuid_father {
		profile_father = infra_profile_adapters.entitie_to_model(repo_profile.get_profile(father_uuid) or {
			entities.Profile{}
		})!
	}

	mut profile_mother := models.ProfileAlias.new()
	if mother_uuid := family.profile_uuid_mother {
		profile_mother = infra_profile_adapters.entitie_to_model(repo_profile.get_profile(mother_uuid) or {
			entities.Profile{}
		})!
	}

	mut profile_brothers := []models.ProfileAlias{}
	if family.profile_uuid_father != none && family.profile_uuid_mother != none {
		father_uuid := family.profile_uuid_father
		mother_uuid := family.profile_uuid_mother
		if father_uuid != none && mother_uuid != none {
			profile_brothers = repo_profile.get_profiles_brothers(profile_required.id,
				family.id or { -1 }).map(models.ProfileAlias(infra_profile_adapters.entitie_to_model(it)!))
		}
	}

	return models.Profile.new_return(
		uuid:             profile_required.uuid
		surname:          profile_required.surname
		age:              profile_required.age
		name_shared_link: profile_required.name_shared_link
		birth_date:       profile_required.birth_date or { constants.time_empty }
		brothers:         profile_brothers
		color:            profile_required.color
		father:           profile_father
		first_name:       profile_required.first_name
		height:           profile_required.height
		last_name:        profile_required.last_name
		mother:           profile_mother
		sex:              types.Sex.from_i8(profile_required.sex)
		weight:           profile_required.weight
	)
}

fn (p ProfileService) contain(uuid string) bool {
	repo_profile := infra_profile_service.get()

	repo_profile.get_profile(uuid) or { return false }

	return true
}

pub fn (p ProfileService) get_default_uuid_from_user(user_uuid string) ?string {
	repo_family := infra_family_service.get()

	family := repo_family.get_by_user(user_uuid) or { return none }

	family_model := infra_family_adapters.entitie_to_model(family)

	_, profile_uuid := family_model.get_uuid_profile_and_user_from_profile_default()
	return profile_uuid
}
