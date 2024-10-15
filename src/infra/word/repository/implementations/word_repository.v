module implementations

import infra.word.repository.errors
import infra.word.entities
import infra.connection
import time

pub struct WordRepository {}

pub fn (wr WordRepository) get_all_by_id(user_uuid string) ![]entities.Word {
	conn := connection.get()

	defer {
		conn.close()
	}

	words := sql conn {
		select from entities.Word where profile_uuid == user_uuid
	}!

	return words
}

pub fn (wr WordRepository) exists_word(word entities.Word) bool {
	conn := connection.get()

	defer {
		conn.close()
	}

	word_found := sql conn {
		select from entities.Word where uuid == word.uuid limit 1
	} or { return false }

	return word_found.len > 0
}

pub fn (wr WordRepository) new_word(word entities.Word) !entities.Word {
	conn := connection.get()

	defer {
		conn.close()
	}

	id := sql conn {
		insert word into entities.Word
	} or { return word }

	// TODO: Melhorar esse fluxo
	word_created := sql conn {
		select from entities.Word where id == id limit 1
	} or { return errors.WordsFailInsert{
		word: word
	} }

	return word_created[0] or { return errors.WordsFailInsert{
		word: word
	} }
}

pub fn (wr WordRepository) update_word(word entities.Word) ! {
	conn := connection.get()

	defer {
		conn.close()
	}

	sql conn {
		update entities.Word set word = word.word, translation = word.translation, pronunciation = word.pronunciation,
		audio_path = word.audio_path, date_speaker = word.date_speaker, updated_at = time.utc()
		where uuid == word.uuid
	} or {
		// TODO: Isso quebra o compilador
		// return errors.WordsFailInsert{
		// 	word: word
		// }
		return error('Falha ao atualizar palavra')
	}
}

pub fn (wr WordRepository) delete_word(word_uuid string) ! {
	conn := connection.get()

	defer {
		conn.close()
	}

	sql conn {
		delete from entities.Word where uuid == word_uuid
	} or {
		return error('Falha ao deletar palavra')
	}
}

pub fn (wr WordRepository) count_words(profile_uuid string) !int {
	conn := connection.get()

	defer {
		conn.close()
	}

	value_result := sql conn {
		select from entities.Word where profile_uuid == profile_uuid limit 1
	} or { return 0 }

	return value_result.len
}
