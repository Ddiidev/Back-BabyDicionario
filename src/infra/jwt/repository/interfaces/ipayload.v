module interfaces

import domain.types

pub interface IPayload {
	iss ?string
	sub ?string
	aud ?string
	exp types.JsTime
	iat types.JsTime
	ext ITokenJwtContract
}
