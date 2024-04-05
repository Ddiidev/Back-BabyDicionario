module confirmation

import domain.types

pub struct RecoveryPassword {
pub:
	email             string
	new_password      string
	code_confirmation string
	current_date      types.JsTime
}

pub fn (rp RecoveryPassword) valid() bool {
	return rp.new_password.trim_space() != '' && rp.email.trim_space() != ''
		&& rp.code_confirmation.trim_space() != ''
}
