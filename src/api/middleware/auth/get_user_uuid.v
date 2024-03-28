module auth

import infra.repository.jwt.service

pub fn get_uuid_from_user(access_token string) ?string {
	handle_jwt := service.get()
	jwt_tok := handle_jwt.get(access_token) or { return none }

	return jwt_tok.payload.sub
}
