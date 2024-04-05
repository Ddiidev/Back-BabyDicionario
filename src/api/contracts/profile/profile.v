module models

import time
import domain.types

// TODO: open issue bug in struct recursive with json.encode
pub struct None {}

pub type ProfileAlias = None | Profile

pub fn ProfileAlias.new() ProfileAlias {
	return ProfileAlias(None{})
}

// BUG: returned with field '_type'
pub struct Profile {
pub:
	uuid       string
	surname    string
	first_name string
	last_name  string
	birth_date time.Time
	age        f64
	weight     f64
	sex        contract_shared.Sex
	height     f64
	color      string
	father     ProfileAlias
	mother     ProfileAlias
	brothers   []ProfileAlias
}
