module interfaces

import infra.entities

pub interface IWord {
	get_all_by_id(user_uuid string) ![]entities.Word
	new_words([]entities.Word) !
}
