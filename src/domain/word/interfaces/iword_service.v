module interfaces

import domain.word.models

pub interface IWordService {
	get_all_by_uuid(short_uuid string, name_profile string) []models.Word
	new_words(short_uuid string, name_profile string, contract_words []models.Word) ![]models.Word
	count_words(profile_uuid string) !int
}
