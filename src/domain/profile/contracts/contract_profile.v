module contracts

import domain.profile.models
import json

pub struct ContractProfile {}

pub fn ContractProfile.adapter(json_str string) !models.Profile {
	return json.decode(models.Profile, json_str)!
}
