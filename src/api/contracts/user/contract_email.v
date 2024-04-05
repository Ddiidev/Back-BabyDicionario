module user

import domain.types

pub struct ContractEmail {
pub:
	first_name  string
	responsible types.Responsible
	birth_date  types.JsTime
	email       string
	password    string
}
