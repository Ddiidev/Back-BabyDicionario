module interfaces

import domain.word.models

pub interface IWordService {
	get_all() []models.Word
}