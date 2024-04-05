module user

import domain.types
import utils

pub struct ContractUser {
pub:
	first_name  string
	last_name   string
	responsible types.Responsible
	birth_date  types.JsTime
	email       string
}

pub fn (cuser ContractUser) valid_all() bool {
	return utils.validating_email(cuser.email) && cuser.first_name != '' && cuser.last_name != ''
		&& utils.validate_time(cuser.birth_date)
}

pub fn (cuser ContractUser) valid_email() bool {
	return utils.validating_email(cuser.email)
}
