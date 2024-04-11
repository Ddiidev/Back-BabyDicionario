module application_services

import infra.recovery.repository.service as recovery_service
import domain.token.services as domain_token_services
import infra.user.repository.service as user_service
import infra.recovery.entities as recovery_entities

pub type HtmlPageBlock = string
const user_not_found = 'O usuário não foi encontrado, logo não será possível bloquea-lo. Por favor entrar em contato via email de suporte.'

pub fn block_user(access_token string) !HtmlPageBlock {
	// TODO: Desacoplar dos repository
	email_dicionario_baby := $env('BABYDI_SMTP_EMAIL_FROM_SUPORT')
	mut message := 'O usuário foi bloqueado com sucesso até que se inicie uma nova recuperação de senha.'
	mut result_html := ""

	htoken_service := domain_token_services.get()

	if !htoken_service.valid(access_token) {
		message = 'Página não encontrada.'
		result_html = $tmpl('./page_block/index.html')
		return error(result_html)
	}

	payload_jwt := htoken_service.payload(access_token) or {
		message = user_not_found
		result_html = $tmpl('./page_block/index.html')
		return error(result_html)
	}

	repo_recovery := recovery_service.get()
	recovery := repo_recovery.get_by_token(access_token) or {
		message = user_not_found
		recovery_entities.UserRecovery{}
	}

	if !recovery.valid_expiration_token() {
		message = user_not_found
	} else if !recovery.valid_expiration_token_block() {
		message = 'O período de bloquear o usuário expirou, caso ainda precise do bloqueio da senha por alteração de senha recentemente, favor entrar em contato por email.'
	}

	repo_users := user_service.get()
	repo_users.blocked_user_from_recovery_password(payload_jwt.email, true) or {
		message = user_not_found
	}

	result_html = $tmpl('./page_block/index.html')

	return result_html
}