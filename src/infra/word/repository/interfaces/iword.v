module interfaces

import word.entities

pub interface IWord {
	get_all_by_id(user_uuid string) ![]entities.Word
	new_words(words []entities.Word) !
}
