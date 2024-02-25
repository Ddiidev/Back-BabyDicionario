module entities

import contracts.profile as contract_profile
import contracts.contract_shared { Sexo }
import time { Time }
import constants

@[table: 'profiles']
pub struct Profile {
pub:
	id               int    @[primary; sql: serial]
	uuid             string
	short_uuid       string
	name_shared_link string
	user_id          int
	apelido          string
	primeiro_nome    string
	segundo_nome     string
	data_nascimento  ?Time  @[default: 'null']
	idade            f64    @[sql_type: 'NUMERIC']
	peso             f64    @[sql_type: 'NUMERIC']
	sexo             Sexo
	altura           f64    @[sql_type: 'NUMERIC']
	cor              string
	pai_id           ?int
	mae_id           ?int
	created_at       Time   @[default: 'CURRENT_TIME']
	updated_at       Time   @[default: 'CURRENT_TIME']
}

pub fn (p Profile) adapter() contract_profile.Profile {
	return contract_profile.Profile{
		uuid: p.uuid
		apelido: p.apelido
		primeiro_nome: p.primeiro_nome
		segundo_nome: p.segundo_nome
		idade: p.idade
		peso: p.peso
		cor: p.cor
		sexo: p.sexo
		altura: p.altura
		data_nascimento: p.data_nascimento or { constants.time_empty }
	}
}

pub fn (p Profile) validated() Profile {
	return Profile{
		...p
		primeiro_nome: p.primeiro_nome.trim_space()
		segundo_nome: p.segundo_nome.trim_space()
		apelido: p.apelido.trim_space()
		cor: p.cor.trim_space()
		short_uuid: p.uuid.all_after_last('-')
		name_shared_link: p.primeiro_nome
	}
}
