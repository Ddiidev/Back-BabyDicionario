module application_service

import domain.profile.services as domain_profile
import infra.family.repository.service as repo_family
// import infra.family.adapters as adapter_family
import domain.profile.models

pub fn create_profile(profile models.Profile, user_uuid string) !models.Profile {
	is_new_baby := profile.uuid == 'newBaby'
	mut profile_param := models.ProfileParam{
		...models.Profile.to_param(profile)
		responsible: match is_new_baby {
			true { .is_not_responsible }
			else { profile.responsible }
		}
	}
	profile_ := models.Profile.new(profile_param)!

	profile_with_responsible := new_profile_responsible(profile_, user_uuid, is_new_baby)!

	update_family_on_profile(profile_with_responsible)!

	// update_family(profile_with_responsible)!

	return profile_with_responsible
}

fn new_profile_responsible(profile models.Profile, user_uuid string, is_new_baby bool) !models.Profile {
	service_family := domain_profile.get_family()
	hfamily := repo_family.get()
	profile_created := new_profile(profile)!

	family_id := hfamily.get_by_user(user_uuid)!.id or { return error('Not found id from family') }

	family := if responsible := profile_created.responsible {
		models.Family.new_profile_with_id(family_id, profile_created.uuid, responsible)!
	} else {
		if !is_new_baby {
			return error('Responsible not found')
		}

		models.Family.new_profile_with_id(family_id, profile_created.uuid, .is_not_responsible)!
	}

	service_family.update_by_id(family)!
	return models.Profile{
		...profile_created
		family_id: family_id
	}
}

fn new_profile(profile models.Profile) !models.Profile {
	hprofile := domain_profile.get()

	return hprofile.create(profile)!
}

fn update_family_on_profile(profile models.Profile) ! {
	hprofile := domain_profile.get()

	hprofile.update_family_id(profile.uuid, profile.family_id)!
}

// fn update_family(profile models.Profile) ! {
// 	hfamily := repo_family.get()

// 	current_responsible := profile.responsible or { return error('Responsável não especificado') }

// 	family_entities := adapter_family.model_to_entitie(models.Family.new_profile_with_id(profile.family_id,
// 		profile.uuid, current_responsible)!)

// 	hfamily.update_by_id(family_entities)!
// }
