module adapters

import domain.word.models
import infra.word.entities

pub fn entitie_to_model(word entities.Word) models.Word {
	return models.Word{
		id:            word.id or { 0 }
		uuid:          word.uuid
		profile_uuid:  word.profile_uuid
		word:          word.word
		translation:   word.translation
		pronunciation: word.pronunciation or { '' }
		audio_path:    word.audio_path or { '' }
		date_speaker:  word.date_speaker
		created_at:    word.created_at
		updated_at:    word.updated_at
	}
}

pub fn model_to_entitie(profile_uuid string, word models.Word) entities.Word {
	return entities.Word{
		id:            word.id
		profile_uuid:  profile_uuid
		uuid:          word.uuid
		word:          word.word
		translation:   word.translation
		pronunciation: word.pronunciation
		audio_path:    word.audio_path
		date_speaker:  word.date_speaker
		created_at:    word.created_at
		updated_at:    word.updated_at
	}
}
