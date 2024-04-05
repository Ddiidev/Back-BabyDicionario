module models

import contracts.contract_shared { Responsible }
import constants
import time

pub struct UserTemp {
pub:
	first_name        string
	last_name         ?string
	responsible       Responsible
	birth_date        time.Time
	email             string
	password          string
	expiration_time   time.Time = constants.time_empty
	code_confirmation string
	created_at        time.Time = time.utc()
	updated_at        time.Time = time.utc()
}

pub fn (u UserTemp) is_expired() bool {
	return u.expiration_time < time.utc().add_seconds(1)
}

pub fn (u UserTemp) adapter() User {
	mut user := User.new(
		first_name: u.first_name
		last_name: u.last_name
		responsible: i8(u.responsible)
		birth_date: u.birth_date
		email: u.email
		password: u.password
		created_at: u.created_at
		updated_at: u.updated_at
	)

	return user
}
