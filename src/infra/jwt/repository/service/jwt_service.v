module service

import infra.jwt.repository.interfaces
import infra.jwt.repository.implementations

pub fn get() interfaces.IJwt {
	return implementations.JwtRepository{}
}