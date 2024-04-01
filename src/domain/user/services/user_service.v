module services

import domain.user.models

pub struct UserService {}

pub fn (u UserService) create(m models.User) !models.User {
	return m
}

pub fn (u UserService) delete_usertemp_if_confirmed_user_exists(user_uuid string) bool {
	return false
}
