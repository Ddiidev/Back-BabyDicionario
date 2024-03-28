module implementations

import infra.repository.words.errors
import infra.entities
import infra.connection

pub struct WordRepository {}

pub fn (wr WordRepository) get_all_by_id(user_uuid string) ![]entities.Word {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	words := sql conn {
		select from entities.Word where profile_uuid == user_uuid
	}!

	return words
}

pub fn (wr WordRepository) new_words(new_words []entities.Word) ! {
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
