module adapters

import domain.profile.models
import infra.profile.entities
import constants

pub fn entitie_to_model(p entities.Profile) !models.Profile {
	return models.Profile.new_for_new_users(
		uuid: p.uuid
		short_uuid: p.short_uuid
		name_shared_link: p.name_shared_link
		family_id: p.family_id
		surname: p.surname
		first_name: p.first_name
		last_name: p.last_name
		birth_date: p.birth_date or { constants.time_empty }
		responsible: p.responsible
		age: p.age
		weight: p.weight
		sex: p.sex
		color: p.color
	)!
}

pub fn model_to_entitie(p models.Profile) (!entities.Profile) {
	return entities.Profile{
		uuid: p.uuid
		short_uuid: p.short_uuid
		name_shared_link: p.name_shared_link
		family_id: p.family_id
		surname: p.surname
		first_name: p.first_name
		last_name: p.last_name
		birth_date: p.birth_date
		responsible: p.responsible
		age: p.age
		weight: p.weight
		sex: p.sex
		color: p.color
	}
}
