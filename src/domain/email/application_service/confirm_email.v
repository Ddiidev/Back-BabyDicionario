module application_service

import infra.user.repository.errors as user_errors
import domain.token.services as email_domains
import domain.email.services as email_domain
import domain.token.models as token_models
import domain.user.services as user_domain
import domain.email.contracts

pub fn confirm_email_by_code(contract contracts.ConfirmationEmailByCode) !token_models.Token {
	huser_confirmation := user_domain.get_user_confirmation()
	user_temp := huser_confirmation.get_by_email_code(contract.email, contract.code)!

	if !user_temp.is_expired() {
		huser := user_domain.get_user()
		user := huser.create(user_temp.adapter())!

		htoken := email_domains.get()
		token_model := htoken.create(user.uuid, user.email, user_temp.expiration_time)!

		dump(token_model)

		hemail := email_domain.get()
		huser.delete_usertemp_if_confirmed_user_exists(user.uuid)!
		hemail.congratulations(user.email, user.first_name)!

		return token_model
	} else {
		return user_errors.ExpirationTime{}
	}
}
