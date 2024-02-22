module entities

import time { Time }
import rand

@[table: 'users']
pub struct User {
pub:
	primeiro_nome string
	segundo_nome  ?string
	responsavel   i8
	idade         f64     @[sql_type: 'NUMERIC']
	email         string
	senha         string
	created_at    Time    @[default: 'CURRENT_TIME']
	updated_at    Time    @[default: 'CURRENT_TIME']
pub mut:
	id   ?int   @[default: 'null'; primary; sql: serial]
	uuid string @[uniq]
}

pub fn (mut u User) generate_uuid() {
	u.uuid = rand.uuid_v4()
}
