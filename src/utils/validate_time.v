module utils

import time

pub fn validate_time(tm string) bool {
	time.parse(tm) or {
		if _ := time.parse_rfc3339(tm) {
			return true
		} else {
			return false
		}
	}
	
	return true
}
