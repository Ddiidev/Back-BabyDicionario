module entities

import domain.types
import infra.jwt.repository.interfaces

pub struct Payload {
pub:
	iss ?string
	sub ?string
	aud ?string
	exp types.JsTime
	iat types.JsTime
	ext interfaces.ITokenJwtContract
}
