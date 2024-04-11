module models

import infra.jwt.repository.service as jwt_service
import constants
import time

@[noinit]
pub struct Token {
pub:
	uuid          string
	access_token  string
	refresh_token string
pub mut:
	refresh_token_expiration time.Time = time.utc()
}

@[params]
pub struct ParamToken {
	uuid                     string    @[required]
	access_token             string    @[required]
	refresh_token            string    @[required]
	refresh_token_expiration time.Time = time.utc()
}

pub fn Token.new(token ParamToken) !Token {
	return if token.access_token.trim_space() != '' && token.refresh_token.trim_space() != '' {
		Token{
			uuid: token.uuid
			access_token: token.access_token
			refresh_token: token.refresh_token
			refresh_token_expiration: time.utc().add_days(constants.day_expiration_refresh_token)
		}
	} else {
		error('Não foi possível instanciar Token')
	}
}

// change_refresh_token_expiration_time Altera o campo refresh_token_expiration, para a qtde de dias padrão para expirar
pub fn (mut t Token) change_refresh_token_expiration_time() ! {
	handle_jwt := jwt_service.get()

	exp_time := handle_jwt.expiration_time(t.access_token) or {
		return error('payload_exp_expired')
	}

	t.refresh_token_expiration = exp_time.add_days(constants.day_expiration_refresh_token)
}
