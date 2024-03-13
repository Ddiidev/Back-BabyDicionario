module user

import contracts.contract_shared { JsTime, Responsible }
import utils

pub struct ContractUser {
pub:
	first_name  string
	last_name   string
	responsible Responsible
	date_birth  JsTime
	email       string
}

pub fn (cuser ContractUser) valid_all() bool {
	return utils.validating_email(cuser.email) && cuser.first_name != '' && cuser.last_name != ''
		&& utils.validate_time(cuser.date_birth)
}

pub fn (cuser ContractUser) valid_email() bool {
	return utils.validating_email(cuser.email)
}
