module interfaces

import infra.profile.entities

pub interface IProfileRepository {
	get_profile(uuid string) ?entities.Profile
	get_profile_by_suuid(uuid string, name_shared_link string) !entities.Profile
	get_profiles_by_id(id int) []entities.Profile
	get_profiles_babys(family_id int) []entities.Profile

	create(profile entities.Profile) !
	update_family_id(uuid string, family_id int) !

	update(profile entities.Profile) !

	// Desativa o perfil
	disabled(profile_uuid string) !
}
