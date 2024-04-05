module entities

import infra.jwt.repository.interfaces

pub struct Token {
	payload   interfaces.IPayload
	token_str string
}

pub fn (t Token) str() string {
	return t.token_str
}
