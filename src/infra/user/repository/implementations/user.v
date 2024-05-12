module implementations

import infra.user.entities
import infra.connection
import infra.user.repository.errors

pub struct UserRepository {}

pub fn (u UserRepository) get_by_uuid(uuid string) !entities.User {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	users_ := sql conn {
		select from entities.User where uuid == uuid
	}!

	return users_[0] or {
		return errors.NoExistUser{}
	}
}

pub fn (u UserRepository) get_by_email_and_pass(email string, password string) !entities.User {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	users_ := sql conn {
		select from entities.User where password == password && email == email
	}!

	return users_[0]!
}

pub fn (u UserRepository) contain_user_with_uuid(uuid string) bool {
	mut conn := connection.get_db()

	defer {
		conn.close() or {}
	}

	name_tb := connection.get_name_table[entities.User]() or { return false }

	prepared := conn.prepare('select count(*) from ${name_tb} where ', [
		['uuid', uuid],
	])

	c := conn.exec_param_many(prepared.query, prepared.params) or { return false }

	return c.first().vals().first() or { '' }.int() > 0
}

pub fn (u UserRepository) get_by_email(email string) !entities.User {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	users := sql conn {
		select from entities.User where email == email limit 1
	}!

	return users[0]!
}

pub fn (u UserRepository) contain_user_with_email(email string) bool {
	mut conn := connection.get_db()

	defer {
		conn.close() or {}
	}

	name_tb := connection.get_name_table[entities.User]() or { return false }

	prepared := conn.prepare('select count(*) from ${name_tb} where ', [
		['email', email],
	])

	c := conn.exec_param_many(prepared.query, prepared.params) or { return false }

	return c.first().vals().first() or { '' }.int() > 0
}

pub fn (u UserRepository) change_password(email string, password string) ! {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	sql conn {
		update entities.User set password = password where email == email
	}!
}

pub fn (u UserRepository) blocked_user_from_recovery_password(email string, block bool) ! {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	sql conn {
		update entities.User set blocked = block where email == email
	}!
}

pub fn (u UserRepository) create(user entities.User) !entities.User {
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
