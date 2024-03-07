module repository_tokens

import infra.entities
import infra.connection
import infra.repository.repository_tokens.errors

pub fn create_token(tok entities.Token) ! {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	tokens_ := sql conn {
		select from entities.Token
		where
			user_uuid == tok.user_uuid &&
			access_token == tok.access_token &&
			refresh_token == tok.refresh_token
	}!

	if tokens_.len == 0 {
		sql conn {
			insert tok into entities.Token
		}!
	} else {
		return errors.TokenExist{}
	}
}

pub fn get_by_uuid(tok entities.Token) !entities.Token {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	tokens_ := sql conn {
		select from entities.Token where user_uuid == tok.user_uuid
	}!

	if tokens_.len == 0 {
		return errors.TokenNoExist{}
	} else {
		return tokens_.first()
	}
}

pub fn get_by_refresh_token(tok entities.Token) !entities.Token {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	tokens_ := sql conn {
		select from entities.Token
		where
			user_uuid == tok.user_uuid &&
			refresh_token == tok.refresh_token
	}!

	if tokens_.len == 0 {
		return errors.RefreshTokenExpired{}
	} else {
		return tokens_.first()
	}
}

pub fn new_refresh_token(tok entities.Token, target_token entities.Token) ! {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	origin_toks := sql conn {
		select from entities.Token where user_uuid == tok.user_uuid
	}!

	if origin_toks.len == 0 {
		create_token(target_token)!
	} else {
		sql conn {
			update entities.Token
			set
				access_token = target_token.access_token,
				refresh_token = target_token.refresh_token,
				refresh_token_expiration = target_token.refresh_token_expiration
			where
				user_uuid == tok.user_uuid
		}!
	}
}

pub fn update_token_by_uuid(tok entities.Token) ! {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	sql conn {
		update entities.Token
		set
			access_token = tok.access_token,
			refresh_token = tok.refresh_token,
			refresh_token_expiration = tok.refresh_token_expiration
		where
			user_uuid == tok.user_uuid
	}!
}