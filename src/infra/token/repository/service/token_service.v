module service

import infra.token.repository.interfaces
import infra.token.repository.implementations

pub fn get() interfaces.ITokenRepository {
	return implementations.TokenRepository{}
}