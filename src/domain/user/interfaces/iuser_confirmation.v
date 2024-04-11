module interfaces

// import infra.user.repository.errors as user_errors
import domain.user.models
import domain.user.contracts

pub interface IUserConfirmationService {
	create(user contracts.ContractEmail) !
	get_by_email_code(email string, code string) !models.UserTemp
}
