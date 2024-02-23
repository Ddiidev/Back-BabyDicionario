module repository_users

import infra.repository.repository_users.errors
import infra.entities
import infra.connection
import vdapter
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

pub fn create_user_valid(user_temp entities.UserTemp) !entities.User {
	mut user := vdapter.adapter[entities.User](user_temp)
	user.generate_uuid()
	user.id = none

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

pub fn delete_user(user_temp entities.UserTemp) ! {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	sql conn {
		delete from entities.UserTemp where email == user_temp.email
	}!
}
