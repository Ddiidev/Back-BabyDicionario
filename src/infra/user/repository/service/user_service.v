module service

import infra.user.repository.interfaces
import infra.user.repository.implementations

pub fn get() interfaces.IUserRepository {
	return implementations.UserRepository{}
}
