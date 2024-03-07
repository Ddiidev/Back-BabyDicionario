module handle_jwt

import contracts.token { TokenJwtContract }
import jwt

pub fn get(access_token string) !jwt.Token[TokenJwtContract] {
	return jwt.from_str[TokenJwtContract](access_token)
}

pub fn valid(tok jwt.Token[TokenJwtContract]) bool {
	return tok.valid($env('BABYDI_SECRETKEY'))
}

pub fn valid_token_str(tok_str string) bool {
	tok := jwt.from_str[TokenJwtContract](tok_str) or { return false }
	return tok.valid($env('BABYDI_SECRETKEY'))
}
