module service

import infra.repository.email.interfaces
import infra.repository.email.implementations

pub fn get() interfaces.IEmail {
	return implementations.EmailRepository{}
}