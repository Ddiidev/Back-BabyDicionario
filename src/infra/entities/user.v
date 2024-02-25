module entities

import entities.errors.errors_user
import time { Time }
import utils.auth
import utils
import rand

@[table: 'users']
pub struct User {
pub:
	primeiro_nome   string
	segundo_nome    ?string
	responsavel     i8
	data_nascimento Time
	email           string
	senha           string
	created_at      Time    @[default: 'CURRENT_TIME']
	updated_at      Time    @[default: 'CURRENT_TIME']
pub mut:
	id               ?int   @[default: 'null'; primary; sql: serial]
	uuid             string @[uniq]
}

pub fn (u User) validated(pass_already_encrypted bool) !User {
	mut user_validated := User{
		...u
		primeiro_nome: u.primeiro_nome.trim_space()
		segundo_nome: u.segundo_nome or { '' }.trim_space()
		email: u.email.trim_space()
		senha: if pass_already_encrypted { u.senha } else { auth.gen_password(u.senha) }
	}

	user_validated.uuid = rand.uuid_v4()

	if utils.validating_email(user_validated.email) {
		return errors_user.UserInvalid{
			msg: 'Email inválido'
		}
	}

	return user_validated
}
