module adapters

import infra.family.entities
import domain.profile.models

pub fn entitie_to_model(entitie entities.Family) models.Family {
	profile_uuid, user := entitie.get_uuid_user_and_profile()
	return models.Family.new(entitie.id, profile_uuid, user, entitie.get_reponsible())
}

pub fn model_to_entitie(model models.Family) entities.Family {
	profile, user := model.get_uuid_user_and_profile()
	return entities.Family.new(model.id, profile, user, model.get_reponsible())
}
