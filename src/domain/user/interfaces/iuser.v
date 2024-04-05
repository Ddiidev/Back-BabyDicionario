module interfaces

import domain.user.models

pub interface IUserService {
	// get_by_email_code(email string, code string) !models.UserTemp
	create(user models.User) !models.User
	// Remove o usuário temporário caso o usuário tenha confirmado sua conta.
	delete_usertemp_if_confirmed_user_exists(user_uuid string) !
}
