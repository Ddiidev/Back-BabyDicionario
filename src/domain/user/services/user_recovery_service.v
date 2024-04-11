module services

import infra.recovery.repository.service as recovery_service
import infra.user.repository.service as user_service
import domain.email.services as domain_email_service
import domain.token.services as domain_token_service
import utils.auth as utils_auth
import domain.user.contracts
import api.middleware.auth
import domain.user.errors
import domain.types
import constants

pub struct UserRecoveryService {}

pub fn (u UserRecoveryService) begin_recover_password(contract contracts.ContractUser) !types.AccessToken {
	if !contract.valid_email() {
		return error(constants.msg_err_json_contract)
	}

	repo_users := user_service.get()
	repo_users_confirmation := user_service.get_user_confirmation()
	if !(repo_users.contain_user_with_email(contract.email)
		|| repo_users_confirmation.contain_user_with_email(contract.email)) {
		return error(constants.msg_err_not_found_email)
	}

	repo_recovery := recovery_service.get()
	if repo_recovery.email_contains_pendenting_recovery_password(contract.email) {
		return error(constants.msg_err_recovery_contain_recovery_password)
	}

	code := utils_auth.random_number()

	hemail_service := domain_email_service.get()
	hemail_service.begin_recovery_password(contract.email, code) or {
		return error(constants.msg_err_send_email)
	}

	token := domain_token_service.get()
	access_tok := token.create_token_for_recovery(contract.email, code)!

	return access_tok
}

pub fn (u UserRecoveryService) redefined_password(contract contracts.RecoveryPassword) ! {
	if !contract.valid() {
		return error(constants.msg_err_json_contract)
	}

	repo_recovery := recovery_service.get()
	user_recovery := repo_recovery.get_by_email(contract.email)!

	if !user_recovery.valid_code_confirmation(contract.code_confirmation) {
		return errors.UserErrorCodeInvaild{}
	}

	if user_recovery.valid() {
		change_password(user_recovery.email, user_recovery.access_token, contract)!
	}
}

fn change_password(email string, access_token string, contract contracts.RecoveryPassword) ! {
	repo_users := user_service.get()
	repo_users.change_password(email, utils_auth.gen_password(contract.new_password)) or {
		return error('Falha na recuperação de senha, tente novamente')
	}

	repo_users.blocked_user_from_recovery_password(email, false) or {
		return error(constants.msg_err_user_fail_unblocked)
	}

	hemail_service := domain_email_service.get()
	hemail_service.recovery_password_refined(email, contract.ip, auth.create_url_block(access_token),
		contract.current_date)!
}
