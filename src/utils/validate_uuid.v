module utils

import regex

const regex_query_uuid = r'^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$'

// is_valid_uuid Valida uma string UUID
pub fn is_valid_uuid(uuid ?string) bool {
	return if uuid_ := uuid {
		if uuid_ == '' {
			false
		} else {
			regex.regex_opt(utils.regex_query_uuid) or { return false }.matches_string(uuid_)
		}
	} else {
		false
	}
}
