module application_service

import domain.profile.models as profile_models

import infra.user.repository.errors as user_errors
import domain.token.services as email_domains
import domain.profile.services as profile_domains
import domain.email.services as email_domain
import domain.token.models as token_models
import domain.user.services as user_domain
import domain.email.contracts
import domain.types

// confirm_email_by_code Confima o usuário com email e código. </br>
// caso esteja correto o código: Será persisitido o usuário, e apagado o usuário temporário de confirmação.
pub fn confirm_email_by_code(contract contracts.ConfirmationEmailByCode) !token_models.Token {
	huser_confirmation := user_domain.get_user_confirmation()
	user_temp := huser_confirmation.get_by_email_code(contract.email, contract.code)!

	if !user_temp.is_expired() {
		huser := user_domain.get_user()
		user := huser.create(user_temp.adapter())!

		htoken := email_domains.get()
		token_model := htoken.create(user.uuid, user.email, user_temp.expiration_time)!

		hprofile := profile_domains.get()
		hfamily := profile_domains.get_family()

		mut profile_model := profile_models.Profile.new_for_new_users(
			first_name: user.first_name
			birth_date: user.birth_date
		)!
		profile_model = hprofile.create(profile_model)!

		family_id := hfamily.create(profile_models.Family.new(
			user.uuid,
			profile_model.uuid,
			types.Responsible.from(user.responsible)!
		))!

		hprofile.update_family_id(profile_model.uuid, family_id)!

		hemail := email_domain.get()
		huser.delete_temporary_user_if_confirmed_user_exists(user.uuid)!
		hemail.congratulations(user.email, user.first_name)!

		return token_model
	} else {
		return user_errors.ExpirationTime{}
	}
}
