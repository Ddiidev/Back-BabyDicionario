module models

@[noinit]
pub struct Word {
	id ?int
pub:
	profile_uuid  string @[json: '-']
	word          string
	translation   string
	pronunciation string
	audio         string
}

@[params]
pub struct WordParam {
pub:
	profile_uuid  string
	word          string @[required]
	translation   string @[required]
	pronunciation string @[required]
	audio         string
}

pub fn Word.new(w WordParam) Word {
	return Word{
		profile_uuid:  w.profile_uuid
		word:          w.word
		translation:   w.translation
		pronunciation: w.pronunciation
		audio:         w.audio
	}
}

pub fn (w Word) is_valid() bool {
	return w.word.trim_space() != '' && w.translation.trim_space() != ''
		&& w.pronunciation.trim_space() != ''
}
