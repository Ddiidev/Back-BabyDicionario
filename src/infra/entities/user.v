module entities

import infra.entities.errors.errors_user
import utils.auth
import constants
import utils
import rand
import time

@[table: 'users']
pub struct User {
pub:
	primeiro_nome   string
	segundo_nome    ?string
	responsavel     int       @[sql_type: 'smallint']
	data_nascimento time.Time
	email           string
	senha           string
	created_at      time.Time = time.utc()
	updated_at      time.Time = time.utc()
	blocked         bool      @[default: 'false']
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
		primeiro_nome: u.primeiro_nome.trim_space()
		segundo_nome: u.segundo_nome or { '' }.trim_space()
		email: u.email.trim_space()
		senha: if pass_already_encrypted { u.senha } else { auth.gen_password(u.senha) }
	}

	user_validated.uuid = rand.uuid_v4()

	if !utils.validating_email(user_validated.email) {
		return errors_user.UserInvalid{
			msg: 'Email inválido'
		}
	}

	return user_validated
}
