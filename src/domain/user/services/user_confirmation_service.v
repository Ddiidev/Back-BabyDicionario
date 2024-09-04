module services

import infra.user.repository.service as user_service
import infra.user.repository.errors as user_errors
import domain.email.services as domain_email
import infra.user.adapters as user_adapters
import domain.user.contracts
import domain.user.models
import utils.auth
import constants

pub struct UserConfirmationService {}

pub fn (u UserConfirmationService) get_by_email_code(email string, code string) !models.UserTemp {
	repo_user := user_service.get_user_confirmation()

	user_model := repo_user.get_user_existing(email) or { return user_errors.NoExistUserTemp{} }

	return user_adapters.user_temp_entitie_to_model(user_model)
}

pub fn (u UserConfirmationService) create(contract contracts.ContractEmail) ! {
	repo_users := user_service.get()
	if repo_users.contain_user_with_email(contract.email) {
		return error(constants.msg_err_email_in_use)
	}

	repo_users_confirmation := user_service.get_user_confirmation()
	user_temp_exist := repo_users_confirmation.get_user_existing(contract.email)
	code_confirmation := if user_temp_exist != none {
		user_temp_exist.code_confirmation
	} else {
		auth.random_number()
	}

	hemail_service := domain_email.get()
	hemail_service.email_from_code_confirmation(contract.email, contract.first_name, code_confirmation) or {
		return error('Falha ao enviar o email de confirmação, verificar se o email está correto')
	}

	if user_temp_exist == none {
		contract_data_nascimento := contract.birth_date.time() or {
			return error('Formato da data de nascimento está inválido')
		}

		user_temp := user_adapters.user_temp_model_to_entitie(models.UserTemp{
			first_name:  contract.first_name
			responsible: contract.responsible
			birth_date:  contract_data_nascimento
			email:       contract.email
			password:    contract.password
		})

		repo_users_confirmation.new_user_confirmation(user_temp, code_confirmation) or {
			return error('Falha ao cadastrar no banco o usuário')
		}
	}
}
