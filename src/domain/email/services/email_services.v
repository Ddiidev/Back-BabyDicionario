module services

import infra.email.repository.service as email_service
import domain.email.services.ext_services

pub struct EmailService {}

pub fn (e EmailService) congratulations(to string, user_name string) ! {
	email := email_service.get()
	email.send(to, '[DiBebê] Grato por estar aqui', ext_services.body_msg_congratulations_html(user_name))!
}
