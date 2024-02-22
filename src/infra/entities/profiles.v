module entities

import time { Time }
import contracts.contract_shared { Sexo }
import contracts.profile as cprofile
import vdapter

@[table: 'profiles']
pub struct Profile {
pub:
	id              int    @[primary; sql: serial]
	uuid            string
	user_id         int
	apelido         string
	primeiro_nome   string
	segundo_nome    string
	data_nascimento Time   @[default: 'CURRENT_TIME']
	idade           f64    @[sql_type: 'NUMERIC']
	peso            f64    @[sql_type: 'NUMERIC']
	sexo            Sexo
	altura          f64    @[sql_type: 'NUMERIC']
	cor             string
	pai_id          int
	mae_id          int
	created_at      Time   @[default: 'CURRENT_TIME']
	updated_at      Time   @[default: 'CURRENT_TIME']
}

pub fn (p Profile) adapter() cprofile.Profile {
	return vdapter.adapter[cprofile.Profile](&p)
}
