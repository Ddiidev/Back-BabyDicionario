module services

import domain.token.interfaces
import infra.jwt.repository.service as jwt_service

pub fn get() interfaces.ITokenService {
	return TokenService{
		repo_jwt: jwt_service.get()
	}
}
