module entities

import contracts.profile as cprofile
import contracts.contract_shared
import time
import constants

@[table: 'profiles']
pub struct Profile {
pub:
	id               int        @[primary; sql: serial]
	uuid             string
	short_uuid       string
	name_shared_link string
	family_id        int
	surname          string
	first_name       string
	last_name        string
	birth_date       ?time.Time @[default: 'null']
	age              f64        @[sql_type: 'NUMERIC']
	weight           f64        @[sql_type: 'NUMERIC']
	sex              contract_shared.Sex
	height           f64        @[sql_type: 'NUMERIC']
	color            string
	father_id        ?int
	mother_id        ?int
	created_at       time.Time = time.utc()
	updated_at       time.Time = time.utc()
}

pub fn (p Profile) adapter() cprofile.ProfileAlias {
	return cprofile.ProfileAlias(cprofile.Profile{
		uuid: p.uuid
		surname: p.surname
		first_name: p.first_name
		last_name: p.last_name
		age: p.age
		weight: p.weight
		color: p.color
		sex: p.sex
		height: p.height
		birth_date: p.birth_date or { constants.time_empty }
	})
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
