module handle_jwt

import jwt

pub fn get[T](access_token string) !jwt.Token[T] {
	return jwt.from_str[T](access_token)
}