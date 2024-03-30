module service

import infra.email.repository.interfaces
import infra.email.repository.implementations

pub fn get() interfaces.IEmail {
	return implementations.EmailRepository{}
}