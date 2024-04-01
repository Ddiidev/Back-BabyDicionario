module interfaces

import time

pub interface IJwtRepository {
	valid(token_str string) bool
	new_jwt(user_uuid string, email string, expiration_time string) string
	payload(token_str string) !IPayload
	expiration_time(token_str string) ?time.Time
	new_object_jwt(user_uuid string, email string, expiration_time string) !IToken
}