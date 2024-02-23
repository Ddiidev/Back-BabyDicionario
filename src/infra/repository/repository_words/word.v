module repository_words

import infra.repository.repository_words.errors
import infra.entities
import infra.connection

pub fn get_all_by_id(user entities.User) ![]entities.Word {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	words := sql conn {
		select from entities.Word where profile_uuid == user.uuid
	}!

	return words
}

pub fn new_words(user entities.User, new_words []entities.Word) ! {
	conn, close := connection.get()
	mut fail_words := []entities.Word{}

	defer {
		close() or {}
	}

	for word in new_words {
		sql conn {
			insert word into entities.Word
		} or { fail_words << word }
	}

	if fail_words.len > 0 {
		return errors.WordsFailInsert{
			words: fail_words
		}
	}
}
