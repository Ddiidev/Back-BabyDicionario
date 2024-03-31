module interfaces

import infra.user.entities

pub interface IUserConfirmationRepository {
	delete(user_temp entities.UserTemp) !
	contain_user_with_email(email string) bool
	get_user_existing(email string) ?entities.UserTemp
	get_user(email string, code string) !entities.UserTemp
	new_user_confirmation(user entities.UserTemp, code_confirmation string) !
}