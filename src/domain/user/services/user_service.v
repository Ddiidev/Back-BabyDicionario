module services

import domain.user.models
import infra.user.repository.service as user_service
import infra.user.adapters as user_adapters

pub struct UserService {}

pub fn (u UserService) create(m models.User) !models.User {
	repo_user := user_service.get()

	user_model := repo_user.create(user_adapters.adapter_user_model_to_entitie(m))!
	return user_adapters.adapter_user_entitie_to_model(user_model)
}

pub fn (u UserService) delete_usertemp_if_confirmed_user_exists(user_uuid string) ! {
	repo_user := user_service.get()
	repo_user_confirmation := user_service.get_user_confirmation()

	if user_model := repo_user.get_user_by_uuid(user_uuid) {
		repo_user_confirmation.delete(user_model.email)!
	} else {
		return
	}
}
