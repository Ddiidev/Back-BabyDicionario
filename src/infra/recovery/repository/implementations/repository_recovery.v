module implementations

import infra.recovery.repository.errors
import infra.recovery.entities
import infra.connection

pub struct RecoveryRepository {}

pub fn (r RecoveryRepository) create(recover entities.UserRecovery) ! {
	conn := connection.get()

	defer {
		conn.close()
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

pub fn (r RecoveryRepository) delete(email string) ! {
	conn := connection.get()

	defer {
		conn.close()
	}

	sql conn {
		delete from entities.UserRecovery where email == email
	}!
}

pub fn (r RecoveryRepository) get_by_email(email string) !entities.UserRecovery {
	conn := connection.get()

	defer {
		conn.close()
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

pub fn (r RecoveryRepository) email_contains_pendenting_recovery_password(email string) bool {
	return if r_ := r.get_by_email(email) {
		r_.valid_expiration_token()
	} else {
		false
	}
}

pub fn (r RecoveryRepository) get_by_token(access_token string) !entities.UserRecovery {
	conn := connection.get()

	defer {
		conn.close()
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
