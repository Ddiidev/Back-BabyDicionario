module services

import domain.email.interfaces

pub fn get() interfaces.IEmailService {
	return EmailService{}
}
