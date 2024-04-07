module services

import infra.email.repository.service as email_service
import domain.email.services.ext_services
import domain.types

pub struct EmailService {}

pub fn (e EmailService) congratulations(to string, user_name string) ! {
	email := email_service.get()
	email.send(to, '[DiBebê] Grato por estar aqui', ext_services.body_msg_congratulations_html(user_name))!
}

const begin_subject = '[DiBebê] Recuperação de senha'

pub fn (e EmailService) begin_recovery_password(to string, code string) ! {
	email := email_service.get()
	email.send(to, begin_subject, ext_services.body_msg_confirmation_recover_user(code))!
}

const subject = '[DiBebê] ⚠️ Senha redefinida'

pub fn (e EmailService) recovery_password_refined(to string, ip string, url_block_user string, date types.JsTime) ! {
	email := email_service.get()
	email.send(to, subject, ext_services.body_password_redefined(ip, url_block_user, date))!
}