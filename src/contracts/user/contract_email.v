module user

import contracts.contract_shared { JsTime, Responsible }

pub struct ContractEmail {
pub:
	first_name  string
	responsible Responsible
	birth_date  JsTime
	email       string
	password    string
}
