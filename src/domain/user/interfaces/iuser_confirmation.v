module interfaces

import domain.user.models

pub interface IUserConfirmationService {
	get_by_email_code(email string, code string) !models.UserTemp
}