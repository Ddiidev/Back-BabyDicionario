module entities

import contracts.contract_shared { Responsible }
import time

@[table: 'users_temp']
pub struct UserTemp {
pub:
	primeiro_nome     string
	segundo_nome      ?string
	responsavel       Responsible @[sql: int; sql_type: 'smallint']
	data_nascimento   time.Time
	email             string
	senha             string
	expiration_time   time.Time = time.utc()
	code_confirmation string
	created_at        time.Time = time.utc()
	updated_at        time.Time = time.utc()
}

pub fn (u UserTemp) is_valid() bool {
	return time.utc().add_seconds(2) < u.expiration_time
}
