module adapters

import domain.word.models
import infra.word.entities

pub fn adapter_word_entitie_to_model(word entities.Word) models.Word {
	return models.Word.new(
		profile_uuid: word.profile_uuid
		word: word.word
		translation: word.translation
		pronunciation: word.pronunciation or { '' }
		audio: word.audio or { '' }
	)
}

pub fn adapter_word_model_to_entitie(profile_uuid string, word models.Word) (entities.Word) {
	return entities.Word{
		profile_uuid: profile_uuid
		word: word.word
		translation: word.translation
		pronunciation: word.pronunciation
		audio: word.audio
	}
}