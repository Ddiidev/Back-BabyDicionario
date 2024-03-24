module repository_users

import infra.repository.repository_users.errors
import utils.auth as auth_pass
import infra.connection
import infra.entities
import time

pub fn new_user_confirmation(user entities.UserTemp, code_confirmation string) ! {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	mut user_temp := entities.UserTemp{
		...user
		expiration_time: time.utc().add(time.hour * 5)
		code_confirmation: code_confirmation
		senha: auth_pass.gen_password(user.senha)
	}

	sql conn {
		insert user_temp into entities.UserTemp
	}!
}

pub fn get_user_temp_confirmation(email string, code string) !entities.UserTemp {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	users_temp := sql conn {
		select from entities.UserTemp where email == email
	}!

	if users_temp.len == 0 {
		return errors.NoExistUserTemp{}
	} else {
		this_user_temp := users_temp.filter(it.code_confirmation == code)

		if this_user_temp.len == 0 {
			return errors.InvalidCode{}
		} else {
			return this_user_temp.first()
		}
	}
}

pub fn get_user_temp_existing(email string) ?entities.UserTemp {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	users_temp := sql conn {
		select from entities.UserTemp where email == email
	} or { return none }

	if users_temp.len == 0 {
		return none
	} else {
		return users_temp.first()
	}
}

pub fn contain_user_temp_with_email(email string) bool {
	mut conn := connection.get_db()

	defer {
		conn.close() or {}
	}

	name_tb := connection.get_name_table[entities.UserTemp]() or { return false }

	prepared := conn.prepare('select count(*) from ${name_tb} where ', [
		['email', email]
	])

	c := conn.exec_param_many(prepared.query, prepared.params) or {
		return false
	}

	return c.first().vals().first() or {''}.int() > 0
}

pub fn create_user_valid(user_temp entities.UserTemp) !entities.User {
	mut user := entities.User{
		primeiro_nome: user_temp.primeiro_nome
		segundo_nome: user_temp.segundo_nome
		responsavel: i8(user_temp.responsavel)
		data_nascimento: user_temp.data_nascimento
		email: user_temp.email
		senha: user_temp.senha
		created_at: user_temp.created_at
		updated_at: user_temp.updated_at
	}.validated(true) or { return err }

	conn, close := connection.get()

	defer {
		close() or {}
	}

	user_existing := sql conn {
		select from entities.User where email == user.email && responsavel == user.responsavel
	}!

	if user_existing.len > 0 {
		return user_existing.first()
	} else {
		sql conn {
			insert user into entities.User
		}!
	}

	return user
}

pub fn delete_usertemp(user_temp entities.UserTemp) ! {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	sql conn {
		delete from entities.UserTemp where email == user_temp.email
	}!
}
