module adapters

import infra.token.entities
import domain.token.models

pub fn adapter_model_to_entities(user_uuid string, model models.Token) entities.Token {
	return entities.Token{
		user_uuid: user_uuid
		access_token: model.access_token
		refresh_token: model.refresh_token
		refresh_token_expiration: model.refresh_token_expiration
	}
}
