module interfaces

import domain.token.models
import domain.types
import time

pub interface ITokenService {
	create(user_uuid string, email string, expiration_time time.Time) !models.Token
	create_token_for_recovery(email string, code string) !types.AccessToken
}
