module interfaces

import infra.user.entities

pub interface IUserRepository {
	blocked_user_from_recovery_password(email string, block bool) !
	change_password(email string, password string) !
	contain_user_with_email(email string) bool
	create(user entities.User) !entities.User
	contain_user_with_uuid(uuid string) bool
	get_by_email_and_pass(email string, password string) !entities.User
	get_by_uuid(uuid string) !entities.User
	get_by_email(email string) !entities.User
}
