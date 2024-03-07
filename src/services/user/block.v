module user

import infra.repository.repository_recovery
import infra.repository.repository_users
import services.ws_context { Context }
import services.handle_jwt
import infra.entities
import x.vweb

const user_not_found = 'O usuário não foi encontrado, logo não será possível bloquea-lo. Por favor entrar em contato via email de suporte.'

@['/block/:access_token']
pub fn (ws &WsUser) block_user(mut ctx Context, access_token string) vweb.Result {
	email_dicionario_baby := $env('BABYDI_SMTP_EMAIL_FROM_SUPORT')
	mut message := 'O usuário foi bloqueado com sucesso até que se inicie uma nova recuperação de senha.'

	jwt_tok := handle_jwt.get(access_token) or {
		message = 'Página não encontrada.'
		return ctx.html($tmpl('./page_block/index.html'))
	}

	if !handle_jwt.valid(jwt_tok) {
		message = user.user_not_found
	}

	recovery := repository_recovery.get_recovery_password_by_token(access_token) or {
		message = user.user_not_found
		entities.UserRecovery{}
	}

	if !recovery.valid_expiration_token() {
		message = user.user_not_found
	} else if !recovery.valid_expiration_token_block() {
		message = 'O período de bloquear o usuário expirou, caso ainda precise do bloqueio da senha por alteração de senha recentemente, favor entrar em contato por email.'
	}

	repository_users.blocked_user_from_recovery_password(jwt_tok.payload.ext.email, true) or {
		message = user.user_not_found
	}

	return ctx.html($tmpl('./page_block/index.html'))
}
