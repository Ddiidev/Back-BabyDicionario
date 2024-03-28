module errors

import infra.entities

pub struct WordsFailInsert {
	Error
pub:
	words []entities.Word
}
