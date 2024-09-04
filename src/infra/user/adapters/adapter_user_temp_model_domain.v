module adapters

import domain.user.models
import infra.user.entities

pub fn user_temp_entitie_to_model(user_temp entities.UserTemp) models.UserTemp {
	return models.UserTemp{
		first_name:        user_temp.first_name
		last_name:         user_temp.last_name
		birth_date:        user_temp.birth_date
		code_confirmation: user_temp.code_confirmation
		created_at:        user_temp.created_at
		email:             user_temp.email
		expiration_time:   user_temp.expiration_time
		password:          user_temp.password
		responsible:       user_temp.responsible
		updated_at:        user_temp.updated_at
	}
}

pub fn user_temp_model_to_entitie(user_temp models.UserTemp) entities.UserTemp {
	return entities.UserTemp{
		first_name:        user_temp.first_name
		last_name:         user_temp.last_name
		birth_date:        user_temp.birth_date
		code_confirmation: user_temp.code_confirmation
		created_at:        user_temp.created_at
		email:             user_temp.email
		expiration_time:   user_temp.expiration_time
		password:          user_temp.password
		responsible:       user_temp.responsible
		updated_at:        user_temp.updated_at
	}
}
