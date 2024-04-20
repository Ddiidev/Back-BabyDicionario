module services

import domain.profile.interfaces

pub fn get_family() interfaces.IFamilyService {
	return FamilyService{}
}
