module models

import time
import math
import rand
import utils
import domain.types

pub struct Profile {
pub:
	uuid             string
	short_uuid       string
	name_shared_link string
	family_id        int
	surname          string
	first_name       string
	last_name        string
	birth_date       time.Time
	responsible      ?types.Responsible
	age              f64
	weight           f64
	sex              types.Sex
	height           f64
	color            string
mut:
	father   ProfileAlias
	mother   ProfileAlias
	brothers []ProfileAlias
}

@[params]
pub struct ProfileParam {
pub:
	uuid             string
	short_uuid       string
	name_shared_link string
	family_id        int
	surname          string
	first_name       string
	last_name        string
	birth_date       time.Time
	responsible      ?types.Responsible
	age              f64
	weight           f64
	sex              types.Sex
	height           f64
	color            string
	father           ProfileAlias
	mother           ProfileAlias
	brothers         []ProfileAlias
}

pub fn Profile.to_param(p Profile) ProfileParam {
	return ProfileParam{
		uuid:             p.uuid
		short_uuid:       p.short_uuid
		name_shared_link: p.name_shared_link
		family_id:        p.family_id
		surname:          p.surname
		first_name:       p.first_name
		last_name:        p.last_name
		birth_date:       p.birth_date
		responsible:      p.responsible
		age:              p.age
		weight:           p.weight
		sex:              p.sex
		height:           p.height
		color:            p.color
		father:           p.father
		mother:           p.mother
		brothers:         p.brothers
	}
}

pub fn Profile.empty() Profile {
	return Profile{}
}

pub fn Profile.new(param ProfileParam) !Profile {
	return if param.first_name.trim_space() == '' {
		error('Um dos campos "primeiro nome", "segundo nome" ou "apelido" estão em brancos.')
	} else if param.age < 0 {
		error('A idade deve ser maior que 0, podendo ser no minímo 0.1')
	} else if param.birth_date > time.utc() {
		error('A data de nascimento não pode ser maior que a data atual (ta no futuro?)')
	} else if param.height < 0 {
		error('A altura deve ser maior que 0, podendo ser no minímo 0.1')
	} else if param.name_shared_link.trim_space() == '' {
		error('O nome de link compartilhado não pode estar em branco')
	} else {
		mut uuid := param.uuid
		if !utils.is_valid_uuid(uuid) {
			uuid = rand.uuid_v4()
		}

		mut suuid := param.short_uuid
		if suuid.trim_space() == '' {
			suuid = rand.hex(12)
		}

		Profile{
			uuid:             uuid
			short_uuid:       suuid
			name_shared_link: param.name_shared_link
			family_id:        param.family_id
			surname:          param.surname
			age:              param.age
			birth_date:       param.birth_date
			responsible:      param.responsible
			brothers:         param.brothers
			color:            param.color
			father:           param.father
			first_name:       param.first_name
			height:           param.height
			last_name:        param.last_name
			mother:           param.mother
			sex:              param.sex
			weight:           param.weight
		}
	}
}

pub fn Profile.new_return(param ProfileParam) !Profile {
	return Profile{
		uuid:             param.uuid
		short_uuid:       param.short_uuid
		name_shared_link: param.name_shared_link
		family_id:        param.family_id
		surname:          param.surname
		age:              param.age
		birth_date:       param.birth_date
		responsible:      param.responsible
		brothers:         param.brothers
		color:            param.color
		father:           param.father
		first_name:       param.first_name
		height:           param.height
		last_name:        param.last_name
		mother:           param.mother
		sex:              param.sex
		weight:           param.weight
	}
}

pub fn Profile.new_for_new_users(param ProfileParam) !Profile {
	return if param.first_name.trim_space() == '' {
		error('Um dos campos "primeiro nome", "segundo nome" ou "apelido" estão em brancos.')
	} else if param.birth_date > time.utc() {
		error('A data de nascimento não pode ser maior que a data atual (ta no futuro?)')
	} else {
		mut age := param.age
		mut uuid := param.uuid
		mut short_uuid := param.short_uuid

		if param.age <= 0 {
			age = calcule_age(param.birth_date)
		}
		if param.uuid == '' {
			uuid = rand.uuid_v4()
		}
		if param.short_uuid == '' {
			short_uuid = rand.hex(12)
		}

		Profile{
			uuid:             uuid
			short_uuid:       short_uuid
			name_shared_link: 'Temp_${param.first_name}'
			family_id:        param.family_id
			surname:          param.surname
			age:              age
			birth_date:       param.birth_date
			responsible:      param.responsible
			brothers:         param.brothers
			color:            param.color
			father:           param.father
			first_name:       param.first_name
			height:           param.height
			last_name:        param.last_name
			mother:           param.mother
			sex:              param.sex
			weight:           param.weight
		}
	}
}

pub fn (mut p Profile) update_father(profile ProfileAlias) {
	p.father = profile
}

pub fn (mut p Profile) update_mother(profile ProfileAlias) {
	p.mother = profile
}

fn calcule_age(birth_date time.Time) f64 {
	mut curr_date := time.now()
	mut age := f64(curr_date.year - birth_date.year)
	mut months := f64(curr_date.month - birth_date.month)

	if months < 0 || (months == 0 && curr_date.day < birth_date.day) {
		age--
		months = 12 - math.abs(months)
	}

	return age + math.round_sig(months * 0.01, 2)
}
