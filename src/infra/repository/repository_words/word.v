module repository_words

import infra.entities
import infra.connection

pub fn get_all_by_id(user entities.User) ![]entities.Word {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	words := sql conn {
		select from entities.Word
		where
			profile_uuid == user.uuid
	}!

	return words
}