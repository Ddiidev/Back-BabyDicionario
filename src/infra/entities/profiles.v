module entities

import time { Time }
import models { Sexo }

@[table: 'profiles']
pub struct Profile {
pub:
	id int
	uuid string
	apelido string
	primeiro_nome string
	segundo_nome string
	data_nascimento Time
	idade f64 @[sql_type: 'NUMERIC']
	peso f64 @[sql_type: 'NUMERIC']
	sexo Sexo
	altura f64 @[sql_type: 'NUMERIC']
	cor string
	pai_id int
	mae_id int
}

pub fn (p Profile) adapter() models.Profile {
	return models.Profile{
		uuid: p.uuid
		apelido: p.apelido
		primeiro_nome: p.primeiro_nome
		segundo_nome: p.segundo_nome
		idade: p.idade
		peso: p.peso
		sexo: p.sexo
		altura: p.altura
		cor: p.cor
		data_nascimento: p.data_nascimento
	}
}