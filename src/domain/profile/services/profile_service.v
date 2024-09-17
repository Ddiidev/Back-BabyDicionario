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

pub fn (p ProfileService) get_family_profiles(uuid_user string) !models.FamilyProfiles {
	repo_profile := infra_profile_service.get()
	repo_family := infra_family_service.get()
	mut family_profiles := models.FamilyProfiles{
		babys: []models.Profile{cap: 1}
	}

	family := repo_family.get_by_user(uuid_user)!
	// _, profile_uuid := family.get_uuid_user_and_profile()
	// profile_required := repo_profile.get_profile(profile_uuid or { '' }) or {
	// 	return error('Perfil não existe')
	// }

	if father_uuid := family.profile_uuid_father {
		entitie_profile := repo_profile.get_profile(father_uuid) or { entities.Profile{} }
		family_profiles.father = infra_profile_adapters.entitie_to_model(entitie_profile)!
	}

	if mother_uuid := family.profile_uuid_mother {
		entitie_profile := repo_profile.get_profile(mother_uuid) or { entities.Profile{} }
		family_profiles.mother = infra_profile_adapters.entitie_to_model(entitie_profile)!
	}

	if family.profile_uuid_father != none && family.profile_uuid_mother != none {
		father_uuid := family.profile_uuid_father
		mother_uuid := family.profile_uuid_mother
		if father_uuid != none && mother_uuid != none {
			family_profiles.babys = repo_profile.get_profiles_brothers(family.id or { -1 }).map(models.Profile{
				...infra_profile_adapters.entitie_to_model(it)!
			})
		}
	}

	return family_profiles
}

pub fn (p ProfileService) get(short_uuid_profile string, name string) !models.Profile {
	repo_profile := infra_profile_service.get()

	profile_required := repo_profile.get_profile_by_suuid(short_uuid_profile, name)!

	return models.Profile{
		uuid:             profile_required.uuid
		surname:          profile_required.surname
		age:              profile_required.age
		name_shared_link: profile_required.name_shared_link
		birth_date:       profile_required.birth_date or { constants.time_empty }
		color:            profile_required.color
		first_name:       profile_required.first_name
		height:           profile_required.height
		last_name:        profile_required.last_name
		sex:              types.Sex.to_sex(profile_required.sex)
		weight:           profile_required.weight
	}
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
	dump(profile_father)
	if father_uuid := family.profile_uuid_father {
		profile_father = infra_profile_adapters.entitie_to_model(repo_profile.get_profile(father_uuid) or {
			entities.Profile{}
		})!
	}

	mut profile_mother := models.ProfileAlias.new()
	// TODO: CHEGA AQUI PAI << ---------------------
	dump(profile_mother)
	if mother_uuid := family.profile_uuid_mother {
		profile_mother = infra_profile_adapters.entitie_to_model(repo_profile.get_profile(mother_uuid) or {
			entities.Profile{}
		})!
	}

	mut profile_brothers := []models.ProfileAlias{}
	dump(profile_brothers)
	if family.profile_uuid_father != none && family.profile_uuid_mother != none {
		father_uuid := family.profile_uuid_father
		mother_uuid := family.profile_uuid_mother
		if father_uuid != none && mother_uuid != none {
			profile_brothers = repo_profile.get_profiles_brothers(family.id or { -1 }).map(models.ProfileAlias(infra_profile_adapters.entitie_to_model(it)!))
		}
	}

	return models.Profile{
		uuid:             profile_required.uuid
		surname:          profile_required.surname
		age:              profile_required.age
		name_shared_link: profile_required.name_shared_link
		birth_date:       profile_required.birth_date or { constants.time_empty }
		color:            profile_required.color
		first_name:       profile_required.first_name
		height:           profile_required.height
		last_name:        profile_required.last_name
		sex:              types.Sex.to_sex(profile_required.sex)
		weight:           profile_required.weight
	}
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
