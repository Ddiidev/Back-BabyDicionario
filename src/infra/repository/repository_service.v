module repository

import infra.words.repository.service as service_word
import infra.words.repository.interfaces as interfaces_word

@[noinit]
pub struct RepositoryService {}

pub fn RepositoryService.word_repository() interfaces_word.IWord {
	return service_word.get()
}

pub fn RepositoryService.email_repository() interfaces_word.IWord {
	return service_word.get()
}