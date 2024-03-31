module interfaces

pub interface IEmailService {
	confirmation_email(to string, user_name string) !
}