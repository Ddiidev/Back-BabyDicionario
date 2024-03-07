module entities

import services.handle_jwt
import time { Time }
import utils

@[table: 'user_recovery']
pub struct UserRecovery {
pub:
	email                 string @[uniq]
	expiration_time       Time   @[default: 'CURRENT_TIME']
	expiration_time_block Time   @[default: 'CURRENT_TIME']
	access_token          string
	code_confirmation     string
	created_at            Time   @[default: 'CURRENT_TIME']
	updated_at            Time   @[default: 'CURRENT_TIME']
}

pub fn (ur UserRecovery) valid_expiration_token() bool {
	return ur.expiration_time >= time.utc()
}

pub fn (ur UserRecovery) valid_expiration_token_block() bool {
	return ur.expiration_time_block >= time.utc()
}

pub fn (ur UserRecovery) valid_code_confirmation(code string) bool {
	return ur.code_confirmation == code
}

pub fn (ur UserRecovery) valid() bool {
	return handle_jwt.valid_token_str(ur.access_token) && utils.validating_email(ur.email)
}