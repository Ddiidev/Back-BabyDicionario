module entities

import infra.user.repository.errors as errors_user
import utils.auth
import constants
import utils
import rand
import time

@[table: 'users']
pub struct User {
pub:
	first_name  string
	last_name   ?string
	responsible int @[sql: int; sql_type: 'int']
	birth_date  time.Time
	email       string
	password    string
	created_at  time.Time = time.utc()
	updated_at  time.Time = time.utc()
	blocked     bool @[default: 'false']
pub mut:
	id   ?int   @[primary; sql: serial]
	uuid string @[uniq]
}

pub fn (u User) validated(pass_already_encrypted bool) !User {
	created_at := if u.created_at == constants.time_empty {
		time.utc()
	} else {
		u.created_at
	}

	updated_at := if u.updated_at == constants.time_empty {
		time.utc()
	} else {
		u.updated_at
	}

	mut user_validated := User{
		...u
		created_at: created_at
		updated_at: updated_at
		first_name: u.first_name.trim_space()
		last_name:  u.last_name or { '' }.trim_space()
		email:      u.email.trim_space()
		password:   if pass_already_encrypted { u.password } else { auth.gen_password(u.password) }
	}

	user_validated.uuid = rand.uuid_v4()

	if !utils.validating_email(user_validated.email) {
		return errors_user.UserInvalid{
			msg: 'Email inválido'
		}
	}

	return user_validated
}
