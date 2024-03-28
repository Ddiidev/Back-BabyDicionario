module interfaces

pub interface IJwt {
	get(access_token string) !IToken[ITokenJwtContract]
	valid(tok IToken[ITokenJwtContract]) bool
	valid_token_str(tok_str string) bool
	new_jwt(user_uuid string, email string, expiration_time string) IToken[ITokenJwtContract]
}