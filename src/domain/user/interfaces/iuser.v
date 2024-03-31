module interfaces

import domain.user.models

pub interface IUserService {
	// get_by_email_code(email string, code string) !models.UserTemp
	create(user models.User) !models.User
}