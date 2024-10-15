module services

import infra.word.repository.service as word_service_repo
import infra.word.adapters as infra_word_adapters
import domain.word.application_service
import domain.word.models
import domain.word.errors
import constants
import rand

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

pub fn (w WordService) save_words(short_uuid string, name_profile string, words []models.Word) ![]models.Word {
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

	mut words_entities := words.map(infra_word_adapters.model_to_entitie(profile_uuid,
		it))

	repo_word := word_service_repo.get()

	for mut word in words_entities {
		if !repo_word.exists_word(word) {
			word.uuid = rand.uuid_v4()
			word = repo_word.new_word(word)!
		} else {
			repo_word.update_word(word)!
		}
	}

	words_model := words_entities.map(infra_word_adapters.entitie_to_model(it))

	return words_model
}

pub fn (w WordService) delete_words(word_uuid string) ! {
	repo_word := word_service_repo.get()

	repo_word.delete_word(word_uuid)!
}

pub fn (w WordService) count_words(profile_uuid string) !int {
	repo_word := word_service_repo.get()

	return repo_word.count_words(profile_uuid)!
}
