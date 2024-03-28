module repository

import infra.repository.words.service as service_word
import infra.repository.words.interfaces as interfaces_word

@[noinit]
pub struct RepositoryService {}

pub fn RepositoryService.word_repository() interfaces_word.IWord {
	return service_word.get()
}

pub fn RepositoryService.email_repository() interfaces_word.IWord {
	return service_word.get()
}