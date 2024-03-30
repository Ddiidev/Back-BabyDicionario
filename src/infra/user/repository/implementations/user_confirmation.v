module implementations

import infra.user.repository.errors
import utils.auth as auth_pass
import infra.user.entities
import infra.connection
import time

pub struct UserConfirmationRepository {}

pub fn (u UserConfirmationRepository) new_user_confirmation(user entities.UserTemp, code_confirmation string) ! {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	mut user_temp := entities.UserTemp{
		...user
		expiration_time: time.utc().add(time.hour * 5)
		code_confirmation: code_confirmation
		password: auth_pass.gen_password(user.password)
	}

	sql conn {
		insert user_temp into entities.UserTemp
	}!
}

pub fn (u UserConfirmationRepository) get_user(email string, code string) !entities.UserTemp {
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

pub fn (u UserConfirmationRepository) get_user_existing(email string) ?entities.UserTemp {
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

pub fn (u UserConfirmationRepository) contain_user_with_email(email string) bool {
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

pub fn (u UserConfirmationRepository) create_user_valid(user_temp entities.UserTemp) !entities.User {
	mut user := entities.User{
		first_name: user_temp.first_name
		last_name: user_temp.last_name
		responsible: i8(user_temp.responsible)
		birth_date: user_temp.birth_date
		email: user_temp.email
		password: user_temp.password
		created_at: user_temp.created_at
		updated_at: user_temp.updated_at
	}.validated(true) or { return err }

	conn, close := connection.get()

	defer {
		close() or {}
	}

	user_existing := sql conn {
		select from entities.User where email == user.email && responsible == user.responsible
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

pub fn (u UserConfirmationRepository) delete(user_temp entities.UserTemp) ! {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	sql conn {
		delete from entities.UserTemp where email == user_temp.email
	}!
}
