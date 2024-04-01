module interfaces

import infra.jwt.repository.interfaces
import domain.token.models
import time

pub interface ITokenService {
	hjwt interfaces.IJwtRepository
	create(user_uuid string, email string, expiration_time time.Time) !models.Token
}