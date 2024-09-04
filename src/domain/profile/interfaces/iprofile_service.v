module interfaces

import domain.profile.models

pub interface IProfileService {
	get_family_from_profile(short_uuid_profile string, name string) !models.Profile
	get_family(user_uuid string) !models.Profile
	create(profile models.Profile) !models.Profile
	update_family_id(uuid string, family_id int) !
	update(profile models.Profile) !
}
