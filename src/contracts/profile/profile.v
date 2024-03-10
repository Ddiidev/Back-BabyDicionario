module profile

import time { Time }
import contracts.contract_shared { Sexo }

//TODO: open issue bug in struct recursive with json.encode 
pub struct None{}
pub type ProfileAlias = Profile | None

pub fn ProfileAlias.new() ProfileAlias {
	return ProfileAlias(None{})
}

// BUG: returned with field '_type'
pub struct Profile {
pub:
	uuid            string
	apelido         string
	primeiro_nome   string
	segundo_nome    string
	data_nascimento Time
	idade           f64
	peso            f64
	sexo            Sexo
	altura          f64
	cor             string
	pai             ProfileAlias
	mae             ProfileAlias
	irmaos          []ProfileAlias
}
