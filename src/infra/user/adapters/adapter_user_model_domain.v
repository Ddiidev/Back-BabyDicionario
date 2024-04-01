module adapters

import domain.user.models
import infra.user.entities

pub fn adapter_user_entitie_to_model(user entities.User) models.User {
	return models.User.new(
		blocked: user.blocked
		uuid: user.uuid
		first_name: user.first_name
		last_name: user.last_name
		birth_date: user.birth_date
		created_at: user.created_at
		email: user.email
		password: user.password
		responsible: user.responsible
		updated_at: user.updated_at
	)
}

pub fn adapter_user_model_to_entitie(user models.User) (entities.User) {
	return entities.User{
		blocked: false
		uuid: user.uuid
		first_name: user.first_name
		last_name: user.last_name
		birth_date: user.birth_date
		created_at: user.created_at
		email: user.email
		password: user.password
		responsible: user.responsible
		updated_at: user.updated_at
	}
}