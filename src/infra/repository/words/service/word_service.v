module service

import infra.repository.words.interfaces
import infra.repository.words.implementations

pub fn get() interfaces.IWord {
	return implementations.WordRepository{}
}