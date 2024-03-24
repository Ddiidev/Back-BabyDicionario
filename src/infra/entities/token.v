module entities

import contracts.token { TokenJwtContract }
import time
import constants
import jwt

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
	tok_jwt := jwt.from_str[TokenJwtContract](t.access_token)!

	exp_jwt := tok_jwt.payload.exp.time() or { return error('payload_exp_invalid') }

	t.refresh_token_expiration = exp_jwt.add_days(constants.day_expiration_refresh_token)
}
