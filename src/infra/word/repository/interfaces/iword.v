module interfaces

import infra.word.entities

pub interface IWord {
	get_all_by_id(user_uuid string) ![]entities.Word
	new_word(word entities.Word) !entities.Word
	update_word(word entities.Word) !
	count_words(profile_uuid string) !int
	exists_word(word entities.Word) bool
	delete_word(word_uuid string) !
}
