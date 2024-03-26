module entities

@[table: 'words']
pub struct Word {
pub:
	profile_uuid  string
	word          string
	translation   string
	pronunciation string
	audio         string
pub mut:
	id ?int @[default: 'null'; primary; serial]
}

pub fn (w Word) valid() bool {
	return w.word.trim_space() != '' && w.profile_uuid.trim_space() != ''
		&& w.translation.trim_space() != ''
}
