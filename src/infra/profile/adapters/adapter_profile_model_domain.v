module adapters

import domain.profile.models
import infra.profile.entities
import constants

pub fn entitie_to_model(p entities.Profile) !models.Profile {
	return models.Profile.new(
		uuid: p.uuid
		surname: p.surname
		first_name: p.first_name
		last_name: p.last_name
		birth_date: p.birth_date or { constants.time_empty }
		age: p.age
		weight: p.weight
		sex: p.sex
		color: p.color
	)!
}

// pub fn model_to_entitie(profile_uuid string, word models.Word) (entities.Word) {
// 	return entities.Word{
// 		profile_uuid: profile_uuid
// 		word: word.word
// 		translation: word.translation
// 		pronunciation: word.pronunciation
// 		audio: word.audio
// 	}
// }
