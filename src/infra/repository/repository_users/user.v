module repository_users

import infra.entities
import infra.connection

pub fn get_user_by_uuid(user entities.User) !entities.User {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	users_ := sql conn {
		select from entities.User where uuid == user.uuid
	}!

	return users_[0] or { entities.User{} }
}

pub fn get_user_by_email_pass(user entities.User) !entities.User {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	users_ := sql conn {
		select from entities.User where password == user.password && email == user.email
	}!

	return users_[0]!
}

pub fn contain_user_with_uuid(uuid string) bool {
	mut conn := connection.get_db()

	defer {
		conn.close() or {}
	}

	name_tb := connection.get_name_table[entities.User]() or { return false }

	prepared := conn.prepare('select count(*) from ${name_tb} where ', [['uuid', uuid]])

	c := conn.exec_param_many(prepared.query, prepared.params) or {
		return false
	}

	return c.first().vals().first() or { '' }.int() > 0
}

pub fn contain_user_with_email(email string) bool {
	mut conn := connection.get_db()

	defer {
		conn.close() or {}
	}
	
	name_tb := connection.get_name_table[entities.User]() or { return false }

	prepared := conn.prepare('select count(*) from ${name_tb} where ', [['email', email]])

	c := conn.exec_param_many(prepared.query, prepared.params) or {
		return false
	}

	return c.first().vals().first() or {''}.int() > 0
}

pub fn change_password(email string, password string) ! {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	sql conn {
		update entities.User set password = password where email == email
	}!
}

pub fn blocked_user_from_recovery_password(email string, block bool) ! {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	sql conn {
		update entities.User set blocked = block where email == email
	}!
}
