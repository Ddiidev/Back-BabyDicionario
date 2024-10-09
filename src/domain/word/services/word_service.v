module services

import infra.word.repository.service as word_service_repo
import infra.word.adapters as infra_word_adapters
import domain.word.application_service
import domain.word.models
import domain.word.errors
import constants

pub struct WordService {}

pub fn (w WordService) get_all_by_uuid(short_uuid string, name_profile string) []models.Word {
	word_repo := word_service_repo.get()

	profile_uuid := application_service.new_word_get_profile_uuid(short_uuid, name_profile) or {
		return []
	}

	words_entitie := word_repo.get_all_by_id(profile_uuid) or { return [] }

	words_model := words_entitie.map(infra_word_adapters.entitie_to_model(it))

	return words_model
}

pub fn (w WordService) new_words(short_uuid string, name_profile string, words []models.Word) ![]models.Word {
	if !words.all(it.is_valid()) {
		return errors.WordsErrorInvalid{
			// TODO: melhorar o texto
			message:    'Não foi possível inserir as seguintes palavras'
			words_fail: words
		}
	}

	profile_uuid := application_service.new_word_get_profile_uuid(short_uuid, name_profile) or {
		return error(constants.msg_err_profile_not_found)
	}

	words_entities := words.map(infra_word_adapters.model_to_entitie(profile_uuid, it))

	// repo_word := word_service_repo.get()

	// words_created := repo_word.new_words(words_entities)!

	// words_model := words_created.map(infra_word_adapters.entitie_to_model(it))

	return []
}

pub fn (w WordService) count_words(profile_uuid string) !int {
	repo_word := word_service_repo.get()

	return repo_word.count_words(profile_uuid)!
}
