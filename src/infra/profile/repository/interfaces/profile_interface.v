module interfaces

import infra.profile.entities

pub interface IProfileRepository {
	get_profile(uuid string) entities.Profile
	get_profile_by_suuid(uuid string, name_shared_link string) !entities.Profile
	get_profiles_by_id(id int) []entities.Profile
	get_profiles_irmaos(profile_required_id int, father_id int, mother_id int) []entities.Profile
}