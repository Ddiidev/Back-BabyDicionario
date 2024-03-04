module repository_users

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
			update entities.UserRecovery
			set
				expiration_time = recover.expiration_time,
				access_token = recover.access_token,
				code_confirmation = recover.code_confirmation
			where
				email == recover.email
		}!
	} else {
		sql conn {
			insert recover into entities.UserRecovery
		}!
	}
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