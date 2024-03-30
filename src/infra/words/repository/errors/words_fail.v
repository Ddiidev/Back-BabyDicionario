module errors

import infra.words.entities

pub struct WordsFailInsert {
	Error
pub:
	words []entities.Word
}
