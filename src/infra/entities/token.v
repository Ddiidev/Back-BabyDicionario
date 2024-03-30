module entities

import infra.jwt.repository.service as jwt_service
import constants
import time

@[table: 'token']
pub struct Token {
pub:
	user_uuid     string @[default: 'null'; primary; serial]
	access_token  string
	refresh_token string
pub mut:
	refresh_token_expiration time.Time = time.utc()
}

pub fn (mut t Token) change_refresh_token_expiration_time() ! {
	handle_jwt := jwt_service.get()

	exp_time := handle_jwt.expiration_time(t.access_token) or { 
		return error('payload_exp_expired')
	 }

	t.refresh_token_expiration = exp_time.add_days(constants.day_expiration_refresh_token)
}
