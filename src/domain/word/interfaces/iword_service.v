module interfaces

import domain.word.models

pub interface IWordService {
	get_all_by_uuid(profile_uuid string) []models.Word
	new_words(profile_uuid string, contract_words []models.Word) !
}
