module errors

import infra.word.entities

pub struct WordsFailInsert {
	Error
pub:
	words []entities.Word
}
