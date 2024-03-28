module service

import infra.repository.jwt.interfaces
import infra.repository.jwt.implementations

pub fn get() interfaces.IJwt {
	return implementations.JwtRepository{}
}