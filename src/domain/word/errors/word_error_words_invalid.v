module errors

import domain.word.models

pub struct WordsErrorInvalid {
	Error
pub:
	message string
	words_fail []models.Word
}

pub fn (w WordsErrorInvalid) msg() string {
	return w.message
}
