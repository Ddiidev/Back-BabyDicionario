module interfaces

import domain.types

pub interface IEmailService {
	congratulations(to string, user_name string) !
	begin_recovery_password(to string, code string) !
	recovery_password_refined(to string, ip string, url_block_user string, date types.JsTime) !
}
