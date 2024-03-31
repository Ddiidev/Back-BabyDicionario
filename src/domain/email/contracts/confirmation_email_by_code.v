module contracts

import json

pub struct ConfirmationEmailByCode {
pub:
	email string
	code  string
}

pub fn ConfirmationEmailByCode.adapter(json_str string) !ConfirmationEmailByCode {
	return json.decode(ConfirmationEmailByCode, json_str)!
}