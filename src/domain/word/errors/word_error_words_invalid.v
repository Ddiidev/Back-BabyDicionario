module errors

import domain.word.models

pub struct WordsErrorInvalid {
	Error
	message string
pub:
	words_fail []models.Word
}

pub fn (w WordsErrorInvalid) msg() string {
	return w.message
}
