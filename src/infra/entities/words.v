module entities

@[table: 'words']
pub struct Word {
pub:
	profile_uuid string
	palavra      string
	traducao     string
	pronuncia    string
	audio        string
pub mut:
	id ?int @[default: 'null'; primary; serial]
}

pub fn (w Word) valid() bool {
	return w.palavra.trim_space() != '' && w.profile_uuid.trim_space() != ''
		&& w.traducao.trim_space() != ''
}
