module services

import domain.user.models

pub struct UserConfirmationService {}

pub fn (u UserConfirmationService) get_by_email_code(email string, code string) !models.UserTemp {
	return models.UserTemp{}
}
