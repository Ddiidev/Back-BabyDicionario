module services

import domain.user.models

pub struct UserService {}

pub fn (u UserService) create(email string, code string) !models.User {
	return models.UserTemp{}
}
