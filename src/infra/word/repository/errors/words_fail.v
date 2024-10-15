module errors

import infra.word.entities

pub struct WordsFailInsert {
	Error
pub:
	word entities.Word
}

pub struct WordsFailDelete {
	Error
pub:
	word_uuid string
}
