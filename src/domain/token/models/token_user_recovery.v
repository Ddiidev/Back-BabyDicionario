module models

import time

pub struct TokenUserRecovery {
pub:
	email                 string
	expiration_time       time.Time
	expiration_time_block time.Time
	access_token          string
	code_confirmation     string
	created_at            time.Time
	updated_at            time.Time
}
