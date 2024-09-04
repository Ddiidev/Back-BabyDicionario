module models

import constants
import time
import rand

@[noinit]
pub struct User {
pub:
	first_name  string
	last_name   ?string
	responsible int
	birth_date  time.Time
	email       string
	password    string
	created_at  time.Time = time.utc()
	updated_at  time.Time = time.utc()
	blocked     bool
	id          ?int
	uuid        string
}

@[params]
pub struct ParamUser {
pub:
	uuid        string = constants.uuid_empty
	blocked     bool
	first_name  string
	last_name   ?string
	responsible int
	birth_date  time.Time
	email       string
	password    string
	created_at  time.Time = time.utc()
	updated_at  time.Time = time.utc()
}

pub fn User.new(puser ParamUser) User {
	mut user := User{
		first_name:  puser.first_name
		last_name:   puser.last_name
		birth_date:  puser.birth_date
		created_at:  puser.created_at
		updated_at:  puser.updated_at
		password:    puser.password
		email:       puser.email
		responsible: puser.responsible
		uuid:        if puser.uuid == constants.uuid_empty { rand.uuid_v4() } else { puser.uuid }
	}

	return user
}
