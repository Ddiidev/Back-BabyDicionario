module auth

import infra.jwt.repository.service

pub fn get_uuid_from_user(access_token string) ?string {
	handle_jwt := service.get()
	payload := handle_jwt.payload(access_token) or { return none }

	return payload.sub
}
