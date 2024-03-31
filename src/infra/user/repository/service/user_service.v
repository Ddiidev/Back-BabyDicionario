module service

import infra.user.repository.interfaces
import infra.user.repository.implementations

pub fn get() interfaces.IUserRepository {
	return implementations.UserRepository{}
}

pub fn get_user_confirmation() interfaces.IUserConfirmationRepository {
	return implementations.UserConfirmationRepository{}
}