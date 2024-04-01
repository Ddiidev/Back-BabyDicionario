module services

import domain.token.interfaces

pub fn get() interfaces.ITokenService  {
	x := map[int]interfaces.ITokenService{} 
	return x[0]
}