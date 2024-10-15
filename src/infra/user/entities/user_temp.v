module entities

import domain.types { Responsible }
import time

@[table: 'users_temp']
pub struct UserTemp {
pub:
	first_name        string
	last_name         ?string
	responsible       Responsible @[sql: int; sql_type: 'int']
	birth_date        time.Time
	email             string
	password          string
	expiration_time   time.Time = time.utc()
	code_confirmation string
	created_at        time.Time = time.utc()
	updated_at        time.Time = time.utc()
}

pub fn (u UserTemp) is_valid() bool {
	return time.utc().add_seconds(2) < u.expiration_time
}
