module services

import domain.user.interfaces

pub fn get_user() interfaces.IUserService {
	return UserService{}
}
