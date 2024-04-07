module services

import domain.token.interfaces

pub fn get() interfaces.ITokenService {
	return TokenService{}
}
