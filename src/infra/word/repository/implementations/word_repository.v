module implementations

import word.repository.errors
import infra.connection
import word.entities

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

pub fn (wr WordRepository) new_words(words []entities.Word) ![]entities.Word {
	conn, close := connection.get()
	mut fail_words := []entities.Word{}
	mut words_created := []entities.Word{cap: words.len}

	defer {
		close() or {}
	}

	for word in words {
		id := sql conn {
			insert word into entities.Word
		} or { 0 }

		// word_created := sql conn {
		// 	select from entities.Word where uuid == word.uuid limit 1
		// }!

		// words_created << word_created[0]
	}

	if fail_words.len > 0 {
		return errors.WordsFailInsert{
			words: fail_words
		}
	}
	return []
}

pub fn (wr WordRepository) count_words(profile_uuid string) !int {
	table_name := connection.get_name_table[entities.Word]() or {
		return error('fail get table name')
	}

	mut conn := connection.get_db()

	defer {
		conn.close() or {}
	}

	prepared := conn.prepare('select count(*) from ${table_name} where ', [
		['profile_uuid', profile_uuid],
	])

	result := conn.exec_param_many(prepared.query, prepared.params) or {
		return error('fail count words')
	}

	if result.len == 0 || result[0]!.vals().len == 0 {
		return error('fail count words')
	}

	value_result := result.first().vals().first() or { '' }

	return value_result.int()
}
