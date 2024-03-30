module service

import words.repository.interfaces
import words.repository.implementations

pub fn get() interfaces.IWord {
	return implementations.WordRepository{}
}