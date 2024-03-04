module confirmation

import contracts.contract_shared

pub struct RecoveryPassword {
pub:
	email    string
	password string
	current_date contract_shared.JsTime
}

pub fn (rp RecoveryPassword) valid() bool {
	return rp.password.trim_space() != '' && rp.email.trim_space() != ''
}
