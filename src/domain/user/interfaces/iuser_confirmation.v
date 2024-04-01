module interfaces

// import infra.user.repository.errors as user_errors
import domain.user.models

pub interface IUserConfirmationService {
	get_by_email_code(email string, code string) !models.UserTemp
}