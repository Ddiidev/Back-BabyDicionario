module models

import time

pub struct User {
pub:
	first_name  string
	last_name   ?string
	responsible int
	birth_date  time.Time
	email       string
	password    string
	created_at  time.Time = time.utc()
	updated_at  time.Time = time.utc()
	blocked     bool
	id          ?int
	uuid        string
}
