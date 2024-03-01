module auth

import services.handle_jwt

pub fn get_uuid_from_user(access_token string) ?string {
	jwt_tok := handle_jwt.get(access_token) or { return none }

	return jwt_tok.payload.sub
}
