module contracts

import domain.types
import json

@[noinit]
pub struct RecoveryPassword {
pub:
	email             string
	new_password      string
	code_confirmation string
	current_date      types.JsTime
	ip                string @[json: '-']
}

pub fn RecoveryPassword.adapter(json_str string) !RecoveryPassword {
	return json.decode(RecoveryPassword, json_str)!
}

pub fn (rp RecoveryPassword) valid() bool {
	return rp.new_password.trim_space() != '' && rp.email.trim_space() != ''
		&& rp.code_confirmation.trim_space() != ''
}
