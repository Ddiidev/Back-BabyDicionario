module user

import infra.recovery.repository.service as recovery_service
import infra.user.repository.service as user_service
import infra.recovery.entities as recovery_entities
import infra.jwt.repository.service as jwt_service
import api.ws_context
import x.vweb

const user_not_found = 'O usuário não foi encontrado, logo não será possível bloquea-lo. Por favor entrar em contato via email de suporte.'

@['/block/:access_token']
pub fn (ws &WsUser) block_user(mut ctx ws_context.Context, access_token string) vweb.Result {
	email_dicionario_baby := $env('BABYDI_SMTP_EMAIL_FROM_SUPORT')
	mut message := 'O usuário foi bloqueado com sucesso até que se inicie uma nova recuperação de senha.'

	handle_jwt := jwt_service.get()
	if !handle_jwt.valid(access_token) {
		message = 'Página não encontrada.'
		return ctx.html($tmpl('./page_block/index.html'))
	}

	payload_jwt := handle_jwt.payload(access_token) or {
		message = user.user_not_found
		return ctx.html($tmpl('./page_block/index.html'))
	}

	repo_recovery := recovery_service.get()
	recovery := repo_recovery.get_recovery_password_by_token(access_token) or {
		message = user.user_not_found
		recovery_entities.UserRecovery{}
	}

	if !recovery.valid_expiration_token() {
		message = user.user_not_found
	} else if !recovery.valid_expiration_token_block() {
		message = 'O período de bloquear o usuário expirou, caso ainda precise do bloqueio da senha por alteração de senha recentemente, favor entrar em contato por email.'
	}

	repo_users := user_service.get()
	repo_users.blocked_user_from_recovery_password(payload_jwt.ext.email, true) or {
		message = user.user_not_found
	}

	return ctx.html($tmpl('./page_block/index.html'))
}
