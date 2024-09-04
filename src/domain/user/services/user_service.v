module services

import domain.token.services as domain_token_services
import infra.user.repository.service as user_service
import infra.user.adapters as user_adapters
import domain.user.contracts
import domain.user.models
import domain.user.errors
import utils.auth
import time

pub struct UserService {}

pub fn (u UserService) login(email string, password string) !contracts.TokenContract {
	user_model := models.User.new(
		email:    email
		password: auth.gen_password(password)
	)

	repo_users := user_service.get()
	user_required := repo_users.get_by_email_and_pass(user_model.email, user_model.password) or {
		return errors.UserErrorEmailOrPasswodInvaild{}
	}

	if user_required.blocked {
		return errors.UserErrorUserBlockedInvaild{}
	}

	htoken_service := domain_token_services.get()

	mut tok_jwt := htoken_service.create(user_required.uuid, user_required.email, time.utc().add(time.hour * 5))!

	tok_jwt.change_refresh_token_expiration_time()!

	return contracts.TokenContract.new(
		access_token:  tok_jwt.access_token
		refresh_token: tok_jwt.refresh_token
	) or { error('Not possible generate token') }
}

pub fn (u UserService) create(m models.User) !models.User {
	repo_user := user_service.get()

	user_model := repo_user.create(user_adapters.model_to_entitie(m))!
	return user_adapters.entitie_to_model(user_model)
}

pub fn (u UserService) delete_temporary_user_if_confirmed_user_exists(user_uuid string) ! {
	repo_user := user_service.get()
	repo_user_confirmation := user_service.get_user_confirmation()

	if user_model := repo_user.get_by_uuid(user_uuid) {
		repo_user_confirmation.delete(user_model.email)!
	}
}

pub fn (u UserService) details(user_uuid string) !models.User {
	repo_user := user_service.get()

	if user_model := repo_user.get_by_uuid(user_uuid) {
		return user_adapters.entitie_to_model(user_model)
	} else {
		return errors.UserErrorNotFoundDetailsUser{}
	}
}
