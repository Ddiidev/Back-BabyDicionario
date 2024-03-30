module service

import word.repository.interfaces
import word.repository.implementations

pub fn get() interfaces.IWord {
	return implementations.WordRepository{}
}