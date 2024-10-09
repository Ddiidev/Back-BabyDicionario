module entities

import time

@[table: 'words']
pub struct Word {
pub:
	profile_uuid  string
	word          string
	translation   string
	pronunciation ?string
	audio_path    ?string
	date_speaker  time.Time = time.utc()
	created_at    time.Time = time.utc()
	updated_at    time.Time
pub mut:
	id   ?int @[default: 'null'; primary; serial]
	uuid string
}

pub fn (w Word) valid() bool {
	return w.word.trim_space() != '' && w.profile_uuid.trim_space() != ''
		&& w.translation.trim_space() != ''
}
