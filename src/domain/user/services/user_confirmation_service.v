module services

import infra.user.repository.service as user_service
import infra.user.repository.errors as user_errors
import infra.user.adapters as user_adapters
import domain.user.models

pub struct UserConfirmationService {}

pub fn (u UserConfirmationService) get_by_email_code(email string, code string) !models.UserTemp {
	repo_user := user_service.get_user_confirmation()

	user_model := repo_user.get_user_existing(email) or { return user_errors.NoExistUserTemp{} }

	return user_adapters.adapter_user_temp_entitie_to_model(user_model)
}
