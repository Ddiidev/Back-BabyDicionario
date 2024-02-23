module auth

import services.handle_jwt
import contracts.token { TokenJwtContract }

pub fn get_user_uuid(access_token string) ?string {
	jwt_tok := handle_jwt.get[TokenJwtContract](access_token) or { return none }

	return jwt_tok.payload.sub
}
