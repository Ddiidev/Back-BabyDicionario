module models

import time

pub struct Word {
pub:
	uuid          string
	id            int    @[json: '-']
	profile_uuid  string @[json: '-']
	word          string
	translation   string
	pronunciation string
	audio_path    ?string   @[json: 'audioPath']
	date_speaker  time.Time @[json: 'dateSpeaker']
	created_at    time.Time @[json: '-']
	updated_at    time.Time @[json: '-']
}

pub fn (w Word) is_valid() bool {
	return w.word.trim_space() != '' && w.translation.trim_space() != ''
		&& w.pronunciation.trim_space() != ''
}
