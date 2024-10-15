module implementations

import infra.user.repository.errors
import utils.auth as auth_pass
import infra.user.entities
import infra.connection
import time

pub struct UserConfirmationRepository {}

pub fn (u UserConfirmationRepository) new_user_confirmation(user entities.UserTemp, code_confirmation string) ! {
	conn := connection.get()

	defer {
		conn.close()
	}

	mut user_temp := entities.UserTemp{
		...user
		expiration_time:   time.utc().add(time.hour * 5)
		code_confirmation: code_confirmation
		password:          auth_pass.gen_password(user.password)
	}

	sql conn {
		insert user_temp into entities.UserTemp
	}!
}

pub fn (u UserConfirmationRepository) get_user(email string, code string) !entities.UserTemp {
	conn := connection.get()

	defer {
		conn.close()
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
	conn := connection.get()

	defer {
		conn.close()
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
	conn := connection.get()

	defer {
		conn.close()
	}

	result := sql conn {
		select from entities.UserTemp where email == email limit 1
	} or { return false }

	return result.len > 0
}

pub fn (u UserConfirmationRepository) delete(email string) ! {
	conn := connection.get()

	defer {
		conn.close()
	}

	sql conn {
		delete from entities.UserTemp where email == email
	}!
}
