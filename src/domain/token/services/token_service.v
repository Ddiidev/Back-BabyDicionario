module services

import infra.recovery.repository.service as recovery_services
import infra.token.repository.service as token_services
import infra.jwt.repository.service as jwt_services
import infra.recovery.adapters as recovery_adapters
import infra.user.repository.service as user_services
import infra.token.adapters as token_adapters
import domain.token.models
import domain.types
import constants
import time
import rand

pub struct TokenService {}

pub fn (t TokenService) valid(access_token string) bool {
	repo_jwt := jwt_services.get()
	return repo_jwt.valid(access_token)
}
pub fn (t TokenService) payload(access_token string) (!models.TokenPayload) {
	repo_jwt := jwt_services.get()
	payload := repo_jwt.payload(access_token)!

	return models.TokenPayload{
		email: payload.ext.email
	}
}

pub fn (t TokenService) create(user_uuid string, email string, expiration_time time.Time) !models.Token {
	repo_jwt := jwt_services.get()
	jwt_tok := repo_jwt.new_jwt(user_uuid, email, expiration_time.str())

	token_model := models.Token.new(
		uuid: user_uuid
		access_token: jwt_tok
		refresh_token: rand.uuid_v4()
	)!

	htoken := token_services.get()

	token_entitie := token_adapters.model_to_entities(token_model)

	htoken.create(token_entitie)!

	return token_model
}

pub fn (t TokenService) create_token_for_recovery(email string, code string) !types.AccessToken {
	expiration_time := time.utc().add(time.minute * 15)
	expiration_time_block := time.utc().add(time.hour * 24)

	repo_jwt := jwt_services.get()
	token_str := repo_jwt.new_jwt(constants.uuid_empty, email, expiration_time.str())

	entitie_adapted := recovery_adapters.model_to_entities(models.TokenUserRecovery{
		email: email
		expiration_time: expiration_time
		expiration_time_block: expiration_time_block
		access_token: token_str
		code_confirmation: code
	})

	repo_recovery := recovery_services.get()
	repo_recovery.create(entitie_adapted) or {
		return error(constants.msg_err_send_email)
	}

	huser_service := user_services.get()

	user_required := huser_service.get_by_email(email)!

	t.update_by_uuid(token_str, user_required.uuid)!

	return token_str
}

pub fn (t TokenService) update_by_uuid(token_str string, user_uuid string) !models.Token {
	token_model := models.Token.new(
		refresh_token: rand.uuid_v4()
		access_token: token_str
		uuid: user_uuid
	)!
	token_entitie := token_adapters.model_to_entities(token_model)

	repo_token := token_services.get()
	repo_token.update_by_uuid(token_entitie)!

	return token_model
}
