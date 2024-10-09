module application_service

import constants
import domain.profile.services as profile_service

pub fn new_word_get_profile_uuid(short_uuid string, name_profile string) !string {
	serv_profile := profile_service.get()

	profile_required := serv_profile.get(short_uuid, name_profile) or {
		return error(constants.msg_err_profile_not_found)
	}

	return profile_required.uuid
}
