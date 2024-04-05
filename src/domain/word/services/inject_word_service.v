module services

import domain.word.interfaces

pub fn get() interfaces.IWordService {
	return WordService{}
}
