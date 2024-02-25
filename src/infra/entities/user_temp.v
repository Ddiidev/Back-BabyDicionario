module entities

import contracts.contract_shared { Responsavel }
import time { Time }

@[table: 'users_temp']
pub struct UserTemp {
pub:
	primeiro_nome     string
	segundo_nome      ?string
	responsavel       Responsavel
	data_nascimento   Time
	email             string
	senha             string
	expiration_time   Time        @[default: 'CURRENT_TIME']
	code_confirmation string
	created_at        Time        @[default: 'CURRENT_TIME']
	updated_at        Time        @[default: 'CURRENT_TIME']
}

pub fn (u UserTemp) is_valid() bool {
	return time.utc().add_seconds(2) < u.expiration_time
}
