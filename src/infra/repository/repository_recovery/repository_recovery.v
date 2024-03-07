module repository_recovery

import infra.repository.repository_users.errors
import infra.entities
import infra.connection

pub fn new_recovery_password(recover entities.UserRecovery) ! {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	recover_existing := sql conn {
		select from entities.UserRecovery where email == recover.email
	}!

	if recover_existing.len > 0 {
		sql conn {
			update entities.UserRecovery set expiration_time = recover.expiration_time, expiration_time_block = recover.expiration_time_block,
			access_token = recover.access_token, code_confirmation = recover.code_confirmation
			where email == recover.email
		}!
	} else {
		sql conn {
			insert recover into entities.UserRecovery
		}!
	}
}

pub fn delete(email string) ! {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	sql conn {
		delete from entities.UserRecovery where email == email
	}!
}

pub fn get_recovery_password(email string) !entities.UserRecovery {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	recover_existing := sql conn {
		select from entities.UserRecovery where email == email
	}!

	return if recover_existing.len > 0 {
		recover_existing.first()
	} else {
		errors.RecoveryNoExist{}
	}
}

pub fn email_contains_pendenting_recovery_password(email string) bool {
	return if r := get_recovery_password(email) {
		r.valid_expiration_token()
	} else {
		false
	}
}

pub fn get_recovery_password_by_token(access_token string) !entities.UserRecovery {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	recover_existing := sql conn {
		select from entities.UserRecovery where access_token == access_token
	}!

	return if recover_existing.len > 0 {
		recover_existing.first()
	} else {
		errors.RecoveryNoExist{}
	}
}