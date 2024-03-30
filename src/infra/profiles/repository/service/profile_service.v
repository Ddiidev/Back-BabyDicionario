module service

import infra.profiles.repository.implementations
import infra.profiles.repository.interfaces

pub fn get() interfaces.IProfileRepository {
	return implementations.ProfileRepository{}
}