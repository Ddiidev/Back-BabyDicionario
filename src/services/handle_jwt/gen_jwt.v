module handle_jwt

import contracts.token { TokenJwtContract }
import jwt

pub fn new_jwt(user_uuid string, email string, expiration_time string) jwt.Token[TokenJwtContract] {
	payload := jwt.Payload{
		sub: user_uuid
		iss: $env('BABYDI_ORG_ISS')
		ext: TokenJwtContract{
			email: email
		}
		exp: expiration_time
	}

	return jwt.Token.new(payload, $env('BABYDI_SECRETKEY'))
}
