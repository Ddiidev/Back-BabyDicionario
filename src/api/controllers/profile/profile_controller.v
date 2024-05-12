module profile

import domain.profile.interfaces
import api.ws_context
import veb

@[noinit]
pub struct WsProfile {
	veb.Middleware[ws_context.Context]
	hprofile_service interfaces.IProfileService
}

pub struct WsProfileParam {
pub:
	hprofile_service interfaces.IProfileService
}

pub fn WsProfile.new(param WsProfileParam) &WsProfile {
	return &WsProfile{
		hprofile_service: param.hprofile_service
	}
}