module interfaces

import domain.profile.models

pub interface IProfileService {
	get_family_from_profile(short_uuid_profile string, name string) !models.Profile
	create(profile models.Profile) (!models.Profile)
	update_family_id(uuid string, family_id int) !
}
