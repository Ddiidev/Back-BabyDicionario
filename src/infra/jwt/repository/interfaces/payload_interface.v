module interfaces

import contracts.contract_shared

pub interface IPayload {
	iss ?string
	sub ?string
	aud ?string
	exp contract_shared.JsTime
	iat contract_shared.JsTime
	ext ITokenJwtContract
}