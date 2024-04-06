module services

import domain.user.interfaces

pub fn get_user_recovery() interfaces.IUserRecoveryService {
	return UserRecoveryService{}
}
