module entities

import domain.types
import time

pub struct None {}

pub type ProfileAlias = None | Profile

@[table: 'profiles']
pub struct Profile {
pub:
	id               int               @[primary; sql: serial]
	uuid             string
	short_uuid       string
	name_shared_link string
	family_id        int
	surname          string
	first_name       string
	last_name        string
	responsible      types.Responsible
	birth_date       ?time.Time        @[default: 'null']
	age              f64               @[sql_type: 'NUMERIC']
	weight           f64               @[sql_type: 'NUMERIC']
	sex              types.Sex
	height           f64               @[sql_type: 'NUMERIC']
	color            string
	created_at       time.Time = time.utc()
	updated_at       time.Time = time.utc()
}

pub fn (p Profile) validated() Profile {
	return Profile{
		...p
		first_name: p.first_name.trim_space()
		last_name: p.last_name.trim_space()
		surname: p.surname.trim_space()
		color: p.color.trim_space()
		short_uuid: p.uuid.all_after_last('-')
		name_shared_link: p.first_name
	}
}
