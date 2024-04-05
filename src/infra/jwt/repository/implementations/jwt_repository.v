module implementations

import infra.jwt.repository.interfaces
import infra.jwt.entities
import time
import jwt

pub struct JwtRepository {}

pub fn (j JwtRepository) valid(token_str string) bool {
	token := jwt.from_str[entities.TokenJwtContract](token_str) or { return false }

	return token.valid($env('BABYDI_SECRETKEY'))
}

pub fn (j JwtRepository) new_jwt(user_uuid string, email string, expiration_time string) string {
	payload := jwt.Payload{
		sub: user_uuid
		iss: $env('BABYDI_ORG_ISS')
		ext: entities.TokenJwtContract{
			email: email
		}
		exp: expiration_time
	}

	return jwt.Token.new(payload, $env('BABYDI_SECRETKEY')).str()
}

pub fn (j JwtRepository) payload(token_str string) !interfaces.IPayload {
	token := jwt.from_str[entities.TokenJwtContract](token_str)!

	return entities.Payload{
		iss: token.payload.iss
		sub: token.payload.sub
		aud: token.payload.aud
		exp: token.payload.exp.str()
		iat: token.payload.iat.str()
		ext: token.payload.ext
	}
}

pub fn (j JwtRepository) expiration_time(token_str string) ?time.Time {
	token := jwt.from_str[entities.TokenJwtContract](token_str) or { return none }

	return token.payload.exp.time()
}

// new_object_jwt(user_uuid string, email string, expiration_time string) IToken
pub fn (j JwtRepository) new_object_jwt(user_uuid string, email string, expiration_time string) !interfaces.IToken {
	payload := jwt.Payload{
		sub: user_uuid
		iss: $env('BABYDI_ORG_ISS')
		ext: entities.TokenJwtContract{
			email: email
		}
		exp: expiration_time
	}
	tok_ := jwt.Token.new(payload, $env('BABYDI_SECRETKEY'))
	return entities.Token{
		token_str: tok_.str()
		payload: interfaces.IPayload(entities.Payload{
			iss: tok_.payload.iss
			sub: tok_.payload.sub
			aud: tok_.payload.aud
			exp: tok_.payload.exp.str()
			iat: tok_.payload.iat.str()
			ext: tok_.payload.ext
		})
	}
}
