module entities

@[table: 'words']
pub struct Word {
pub:
	id           int    @[primary; serial; default: 'null']
	profile_uuid string
	palavra      string
	traducao     string
	pronuncia    string
	audio        string
}
