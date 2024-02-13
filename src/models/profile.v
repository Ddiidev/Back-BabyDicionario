module models

import time { Time }

pub struct Profile {
pub:
	uuid string
	apelido string
	primeiro_nome string
	segundo_nome string
	data_nascimento Time
	idade f64
	peso f64
	sexo Sexo
	altura f64
	cor string
	pai ?&Profile
	mae ?&Profile
	irmaos []Profile
}

