module handle_jwt

import contracts.token { TokenJwtContract }
import jwt

pub fn get(access_token string) !jwt.Token[TokenJwtContract] {
	return jwt.from_str[TokenJwtContract](access_token)
}
