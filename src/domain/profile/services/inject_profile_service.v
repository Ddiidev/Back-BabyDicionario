module services

import domain.profile.interfaces

pub fn get() interfaces.IProfileService {
	return ProfileService{}
}
