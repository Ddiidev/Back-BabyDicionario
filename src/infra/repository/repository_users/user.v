module repository_users

import infra.entities
import infra.connection

pub fn get_user(user entities.User) !entities.User {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	users_ := sql conn {
		select from entities.User where uuid == user.uuid && email == user.email
	}!

	return users_[0] or { entities.User{} }
}

pub fn contain_user_by_uuid(uuid string) bool {
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
