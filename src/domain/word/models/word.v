module models

pub struct Word {
pub:
	id            ?int
	profile_uuid  string
	word          string
	translation   string
	pronunciation string
	audio         string
}

pub fn (w Word) valid() bool {
	return w.word.trim_space() != '' && w.profile_uuid.trim_space() != ''
		&& w.translation.trim_space() != ''
}
