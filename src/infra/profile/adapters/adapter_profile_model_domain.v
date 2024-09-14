module adapters

import domain.profile.models
import infra.profile.entities
import domain.types
import constants

pub fn entitie_to_model(p entities.Profile) !models.Profile {
	return models.Profile.new(
		uuid:             p.uuid
		short_uuid:       p.short_uuid
		name_shared_link: p.name_shared_link
		family_id:        p.family_id
		surname:          p.surname
		first_name:       p.first_name
		last_name:        p.last_name
		birth_date:       p.birth_date or { constants.time_empty }
		responsible:      types.Responsible.from_i8(p.responsible)
		age:              p.age
		weight:           p.weight
		sex:              types.Sex.from_i8(p.sex)
		color:            p.color
	)!
}

pub fn model_to_entitie(p models.Profile) !entities.Profile {
	responsible := if resp_temp := p.responsible {
		resp_temp.to_i8()
	} else {
		types.Responsible.from_i8(p.sex.to_i8()) or { types.Responsible.pai }.to_i8()
	}

	return entities.Profile{
		uuid:             p.uuid
		short_uuid:       p.short_uuid
		name_shared_link: p.name_shared_link
		family_id:        p.family_id
		surname:          p.surname
		first_name:       p.first_name
		last_name:        p.last_name
		birth_date:       p.birth_date
		responsible:      responsible
		age:              p.age
		weight:           p.weight
		height:           p.height
		sex:              p.sex.to_i8()
		color:            p.color
	}
}
