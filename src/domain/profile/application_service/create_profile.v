module application_service

import domain.profile.services as domain_profile
import infra.family.repository.service as repo_family
import domain.profile.models

pub fn create_profile(profile models.Profile, user_uuid string) !models.Profile {
	mut profile_param := models.Profile.to_param(profile)
	profile_ := models.Profile.new(profile_param)!

	if profile.responsible == none {
		return new_profile(profile_)!
	} else {
		profile_with_responsible := new_profile_responsible(profile_, user_uuid)!

		update_family_profile(profile_with_responsible)!

		return profile_with_responsible
	}
}

fn new_profile_responsible(profile models.Profile, user_uuid string) !models.Profile {
	hprofile_family := domain_profile.get_family()
	hfamily := repo_family.get()
	profile_created := new_profile(profile)!

	family_id := hfamily.get_by_user(user_uuid)!.id or { return error('Not found id from family') }

	family := if responsible := profile_created.responsible {
		models.Family.new_profile_with_id(family_id, profile_created.uuid, responsible)!
	} else {
		return error('Responsible not found')
	}

	hprofile_family.update_by_id(family)!
	return models.Profile{
		...profile_created
		family_id: family_id
	}
}

fn new_profile(profile models.Profile) !models.Profile {
	hprofile := domain_profile.get()

	return hprofile.create(profile)!
}

fn update_family_profile(profile models.Profile) ! {
	hprofile := domain_profile.get()

	hprofile.update_family_id(profile.uuid, profile.family_id)!
}
