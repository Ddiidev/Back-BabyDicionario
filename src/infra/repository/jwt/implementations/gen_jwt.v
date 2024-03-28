module implementations

import infra.entities
import jwt

pub fn (j JwtRepository) new_jwt(user_uuid string, email string, expiration_time string) jwt.Token[entities.TokenJwtContract] {
	payload := jwt.Payload{
		sub: user_uuid
		iss: $env('BABYDI_ORG_ISS')
		ext: entities.TokenJwtContract{
			email: email
		}
		exp: expiration_time
	}

	return jwt.Token.new(payload, $env('BABYDI_SECRETKEY'))
}
