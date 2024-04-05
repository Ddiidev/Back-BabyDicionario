module models

import time
import domain.types

@[noinit]
pub struct Profile {
pub:
	uuid       string
	surname    string
	first_name string
	last_name  string
	birth_date time.Time
	age        f64
	weight     f64
	sex        types.Sex
	height     f64
	color      string
mut:
	father   ProfileAlias
	mother   ProfileAlias
	brothers []ProfileAlias
}

@[params]
pub struct ProfileParam {
	uuid string
pub:
	surname    string
	first_name string
	last_name  string
	birth_date time.Time
	age        f64
	weight     f64
	sex        types.Sex
	height     f64
	color      string
	father     ProfileAlias
	mother     ProfileAlias
	brothers   []ProfileAlias
}

pub fn Profile.empty() Profile {
	return Profile{}
}

pub fn Profile.new(param ProfileParam) !Profile {
	return if param.first_name.trim_space() == '' || param.surname.trim_space() == ''
		|| param.last_name.trim_space() == '' {
		error('Um dos campos "primeiro nome", "segundo nome" ou "apelido" estão em brancos.')
	} else if param.age < 0 {
		error('A idade deve ser maior que 0, podendo ser no minímo 0.1')
	} else if param.birth_date > time.utc() {
		error('A data de nascimento não pode ser maior que a data atual (ta no futuro?)')
	} else if param.height < 0 {
		error('A altura deve ser maior que 0, podendo ser no minímo 0.1')
	} else {
		Profile{
			uuid: param.uuid
			surname: param.surname
			age: param.age
			birth_date: param.birth_date
			brothers: param.brothers
			color: param.color
			father: param.father
			first_name: param.first_name
			height: param.height
			last_name: param.last_name
			mother: param.mother
			sex: param.sex
			weight: param.weight
		}
	}
}

pub fn (mut p Profile) update_father(profile ProfileAlias) {
	p.father = profile
}

pub fn (mut p Profile) update_mother(profile ProfileAlias) {
	p.mother = profile
}
