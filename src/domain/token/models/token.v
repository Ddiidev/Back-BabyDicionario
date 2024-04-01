module models

import time
import constants

@[noinit]
pub struct Token {
pub:
	access_token             string
	refresh_token            string
	refresh_token_expiration time.Time = time.utc()
}

@[params]
pub struct ParamToken {
	access_token             string    @[required]
	refresh_token            string    @[required]
	refresh_token_expiration time.Time = time.utc()
}

pub fn Token.new(token ParamToken) !Token {
	return if token.access_token.trim_space() != '' && token.refresh_token.trim_space() != '' {
		Token{
			access_token: token.access_token
			refresh_token: token.refresh_token
			refresh_token_expiration: time.utc().add_days(constants.day_expiration_refresh_token)
		}
	} else {
		error('Não foi possível instanciar Token')
	}
}