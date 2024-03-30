module entities

import contracts.contract_shared
import infra.jwt.repository.interfaces

pub struct Payload {
pub:
	iss ?string
	sub ?string
	aud ?string
	exp contract_shared.JsTime
	iat contract_shared.JsTime
	ext interfaces.ITokenJwtContract
}