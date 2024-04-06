module services

import infra.recovery.repository.service as recovery_service
import infra.email.repository.service as email_service
import infra.user.repository.service as user_service
import domain.user.services.ext_recovery
import utils.auth as utils_auth
import domain.user.contracts
import api.middleware.auth
import domain.user.errors
import constants

pub struct UserRecoveryService {}

const subject = '[DiBebê] ⚠️ Senha redefinida'

pub fn (u UserRecoveryService) recover_password(contract contracts.RecoveryPassword) ! {
	if !contract.valid() {
		return error(constants.msg_err_json_contract)
	}

	repo_recovery := recovery_service.get()
	user_recovery := repo_recovery.get_recovery_password(contract.email)!

	if !user_recovery.valid_code_confirmation(contract.code_confirmation) {
		return errors.UserErrorCodeInvaild{}
	}

	if user_recovery.valid() {
		repo_users := user_service.get()
		repo_users.change_password(user_recovery.email, utils_auth.gen_password(contract.new_password)) or {
			return error('Falha na recuperação de senha, tente novamente')
		}

		repo_users.blocked_user_from_recovery_password(user_recovery.email, false) or {
			return error(constants.msg_err_user_fail_unblocked)
		}

		body := ext_recovery.body_password_redefined(contract.ip, auth.create_url_block(user_recovery.access_token),
			contract.current_date)

		email := email_service.get()
		email.send(user_recovery.email, services.subject, body) or {
			// TODO: add log
		}
	}
}
