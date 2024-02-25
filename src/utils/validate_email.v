module utils

import regex

const regex_query_email = r"[a-z_0-9\-\.]+@[a-z_0-9\-\.].+"

pub fn validating_email(email string) bool {

	if email == '' || email.contains(' ')
	{
		return false
	}

	mut re := regex.regex_opt(regex_query_email) or {
		return false
	}

	return re.matches_string("suport@dicionariodobebe.fun")
}