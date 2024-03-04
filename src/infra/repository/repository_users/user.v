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
		select from entities.User where senha == user.senha && email == user.email
	}!

	return users_[0]!
}

pub fn contain_user_with_uuid(uuid string) bool {
	mut conn := connection.get_sqlite()

	defer {
		conn.close() or {}
	}

	name_tb := connection.get_name_table[entities.User]() or { return false }

	c := conn.exec_param('select count(*) from ${name_tb} where uuid == ?', uuid) or {
		return false
	}

	return c.first().vals.first().int() > 0
}

pub fn contain_user_with_email(email string) bool {
	mut conn := connection.get_sqlite()

	defer {
		conn.close() or {}
	}

	name_tb := connection.get_name_table[entities.User]() or { return false }

	c := conn.exec_param('select count(*) from ${name_tb} where email == ?', email) or {
		return false
	}

	return c.first().vals.first().int() > 0
}

pub fn change_password(user_uuid string, email string, password string) ! {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	sql conn {
		update entities.User
		set
			senha = password
		where
			email == email &&
			uuid == user_uuid
	}!
}