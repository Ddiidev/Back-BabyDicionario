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
