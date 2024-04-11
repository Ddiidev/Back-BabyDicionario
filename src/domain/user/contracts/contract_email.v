module contracts

import domain.types
import json

pub struct ContractEmail {
pub:
	first_name  string
	responsible types.Responsible
	birth_date  types.JsTime
	email       string
	password    string
}

pub fn ContractEmail.adapter(json_str string) !ContractEmail {
	return json.decode(ContractEmail, json_str)!
}
