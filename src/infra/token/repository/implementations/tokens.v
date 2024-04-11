module implementations

import infra.token.repository.errors
import infra.token.entities
import infra.connection

pub struct TokenRepository {}

pub fn (t TokenRepository) create(tok entities.Token) ! {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	tokens_ := sql conn {
		select from entities.Token where user_uuid == tok.user_uuid && access_token == tok.access_token
		&& refresh_token == tok.refresh_token
	}!

	if tokens_.len == 0 {
		sql conn {
			insert tok into entities.Token
		}!
	} else {
		return errors.TokenAlreadyExist{}
	}
}

pub fn (t TokenRepository) get_by_uuid(tok entities.Token) !entities.Token {
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

pub fn (t TokenRepository) get_by_refresh_token(tok entities.Token) !entities.Token {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	tokens_ := sql conn {
		select from entities.Token where user_uuid == tok.user_uuid
		&& refresh_token == tok.refresh_token
	}!

	if tokens_.len == 0 {
		return errors.RefreshTokenExpired{}
	} else {
		return tokens_.first()
	}
}

pub fn (t TokenRepository) new_refresh_token(tok entities.Token, target_token entities.Token) ! {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	origin_toks := sql conn {
		select from entities.Token where user_uuid == tok.user_uuid
	}!

	if origin_toks.len == 0 {
		t.create(target_token)!
	} else {
		sql conn {
			update entities.Token set access_token = target_token.access_token, refresh_token = target_token.refresh_token,
			refresh_token_expiration = target_token.refresh_token_expiration where user_uuid == tok.user_uuid
		}!
	}
}

pub fn (t TokenRepository) update_by_uuid(tok entities.Token) ! {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	sql conn {
		update entities.Token set access_token = tok.access_token, refresh_token = tok.refresh_token,
		refresh_token_expiration = tok.refresh_token_expiration where user_uuid == tok.user_uuid
	}!
}
