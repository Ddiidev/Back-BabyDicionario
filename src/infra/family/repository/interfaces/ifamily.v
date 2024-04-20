module interfaces

import infra.family.entities

pub interface IFamilyRepository {
	get_by_father(uuid string) !entities.Family
	get_by_mother(uuid string) !entities.Family
	get_by_id(id int) !entities.Family
}
