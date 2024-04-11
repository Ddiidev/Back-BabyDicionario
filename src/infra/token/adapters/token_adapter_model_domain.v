module adapters

import infra.token.entities
import domain.token.models

pub fn model_to_entities(model models.Token) entities.Token {
	return entities.Token{
		user_uuid: model.uuid
		access_token: model.access_token
		refresh_token: model.refresh_token
		refresh_token_expiration: model.refresh_token_expiration
	}
}
