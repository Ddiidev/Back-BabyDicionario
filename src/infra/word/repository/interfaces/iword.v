module interfaces

import word.entities

pub interface IWord {
	get_all_by_id(user_uuid string) ![]entities.Word
	new_words(words []entities.Word) ![]entities.Word
	count_words(profile_uuid string) !int
}
