module services

import domain.user.interfaces

pub fn get_user_confirmation() interfaces.IUserConfirmationService {
	return UserConfirmationService{}
}