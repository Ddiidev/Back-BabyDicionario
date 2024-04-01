module services

import infra.jwt.repository.interfaces as jwt_interfaces
import infra.token.repository.service as token_services
import infra.token.adapters as token_adapters
import domain.token.models { Token }
import time
import rand

pub struct TokenService {
	hjwt jwt_interfaces.IJwtRepository
}

pub fn (t TokenService) create(user_uuid string, email string, expiration_time time.Time) !Token {

	jwt_tok := t.hjwt.new_jwt(user_uuid, email, expiration_time.str())

	token_model := models.Token.new(access_token: jwt_tok, refresh_token: rand.uuid_v4())!

	htoken := token_services.get()
	
	token_entitie := token_adapters.adapter_model_to_entities(user_uuid, token_model)
	htoken.create(token_entitie)!

	return token_model
}