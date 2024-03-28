module interfaces

import infra.entities
import time { Time }

pub interface IPayload[T] {
	iss 	?string
	sub 	?string
	aud 	?string
	exp 	entities.JsTime
	iat 	entities.JsTime
	ext 	T
	time()	?Time
}