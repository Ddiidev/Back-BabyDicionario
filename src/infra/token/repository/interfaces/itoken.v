module interfaces

import infra.token.entities

pub interface ITokenRepository {
	create(tok entities.Token) !
	update_by_uuid(tok entities.Token) !
	get_by_uuid(tok entities.Token) !entities.Token
	get_by_refresh_token(tok entities.Token) !entities.Token
	new_refresh_token(tok entities.Token, target_token entities.Token) !
}
