module application_service

import domain.email.contracts
import domain.user.services as user_sevices

pub fn confirmation_code(contract contracts.ConfirmationEmailByCode) ! {
	huser_confirmation := user_sevices.get_user_confirmation()
	user_temp := huser_confirmation.get_by_email_code(contract.email, contract.code)!

	if user_temp.is_valid() {
		huser := user_sevices.get_user()
		user := huser.create(user_temp.adapter())!
		

	} else {
		return error('Usuário é inválido, dados incompatíveis')
	}
}