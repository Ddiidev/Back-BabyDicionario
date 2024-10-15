module service

import infra.word.repository.interfaces
import infra.word.repository.implementations

pub fn get() interfaces.IWord {
	return implementations.WordRepository{}
}
