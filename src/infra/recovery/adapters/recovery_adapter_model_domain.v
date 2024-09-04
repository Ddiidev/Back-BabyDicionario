module adapters

import infra.recovery.entities
import domain.token.models

pub fn model_to_entities(model models.TokenUserRecovery) entities.UserRecovery {
	return entities.UserRecovery{
		email:                 model.email
		expiration_time:       model.expiration_time
		expiration_time_block: model.expiration_time_block
		access_token:          model.access_token
		code_confirmation:     model.code_confirmation
	}
}
