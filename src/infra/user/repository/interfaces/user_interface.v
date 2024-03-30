module interfaces

import infra.user.entities

pub interface IUserRepository {
	blocked_user_from_recovery_password(email string, block bool) !
	get_user_by_email_pass(user entities.User) !entities.User
	get_user_by_uuid(user entities.User) !entities.User
	change_password(email string, password string) !
	contain_user_with_email(email string) bool
	contain_user_with_uuid(uuid string) bool
}