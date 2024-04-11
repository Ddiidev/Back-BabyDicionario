module entities

import time

@[table: 'tokens']
pub struct Token {
pub:
	user_uuid     string @[default: 'null'; primary; serial]
	access_token  string
	refresh_token string
pub mut:
	refresh_token_expiration time.Time = time.utc()
}
