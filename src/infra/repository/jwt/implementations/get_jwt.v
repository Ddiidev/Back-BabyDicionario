module implementations

import infra.entities
import jwt

pub fn (j JwtRepository) get(access_token string) !jwt.Token[entities.TokenJwtContract] {
	return jwt.from_str[entities.TokenJwtContract](access_token)
}

pub fn (j JwtRepository) valid(tok jwt.Token[entities.TokenJwtContract]) bool {
	return tok.valid($env('BABYDI_SECRETKEY'))
}

pub fn (j JwtRepository) valid_token_str(tok_str string) bool {
	tok := jwt.from_str[entities.TokenJwtContract](tok_str) or { return false }
	return tok.valid($env('BABYDI_SECRETKEY'))
}
