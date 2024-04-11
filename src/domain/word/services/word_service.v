module services

import infra.word.repository.service as word_service_repo
import infra.word.adapters as infra_word_adapters
import domain.word.models
import domain.word.errors

pub struct WordService {}

pub fn (w WordService) get_all_by_uuid(profile_uuid string) []models.Word {
	word_repo := word_service_repo.get()

	words_entitie := word_repo.get_all_by_id(profile_uuid) or { return [] }

	words_model := words_entitie.map(infra_word_adapters.entitie_to_model(it))

	return words_model
}

pub fn (w WordService) new_words(profile_uuid string, words []models.Word) ! {
	if !words.all(it.is_valid()) {
		return errors.WordsErrorInvalid{
			// TODO: melhorar o texto
			message: 'Não foi possível inserir as seguintes palavras'
			words_fail: words
		}
	}

	words_entities := words.map(infra_word_adapters.model_to_entitie(profile_uuid, it))

	repo_word := word_service_repo.get()

	repo_word.new_words(words_entities)!
}
