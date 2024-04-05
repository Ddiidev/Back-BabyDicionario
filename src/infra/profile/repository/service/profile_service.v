module service

import infra.profile.repository.implementations
import infra.profile.repository.interfaces

pub fn get() interfaces.IProfileRepository {
	return implementations.ProfileRepository{}
}
