module application_service

import domain.token.models as token_momdels
import domain.token.services as token_sevices
import domain.email.services as email_service
import domain.user.services as user_sevices
import domain.email.contracts

pub fn confirm_email_by_code(contract contracts.ConfirmationEmailByCode) !token_momdels.Token {
	huser_confirmation := user_sevices.get_user_confirmation()
	user_temp := huser_confirmation.get_by_email_code(contract.email, contract.code)!

	if user_temp.is_valid() {
		huser := user_sevices.get_user()
		user := huser.create(user_temp.adapter())!

		htoken := token_sevices.get()
		token_model := htoken.create(user.uuid, user.email, user_temp.expiration_time)!

		hemail := email_service.get()
		huser.delete_usertemp_if_confirmed_user_exists(user.uuid)
		hemail.congratulations(user.email, user.first_name)!

		return token_model
	} else {
		return error('Usuário é inválido, dados incompatíveis')
	}
}