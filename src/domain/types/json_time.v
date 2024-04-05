module types

import time { Time }

pub type JsTime = string

pub fn (js JsTime) time() ?Time {
	return time.parse(js) or { return time.parse_rfc3339(js) or { none } }
}
