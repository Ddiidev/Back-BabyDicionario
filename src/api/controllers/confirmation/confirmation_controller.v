module confirmation

import domain.user.interfaces
import api.ws_context
import veb

@[noinit]
pub struct WsConfirmation {
	veb.Middleware[ws_context.Context]
	hrecovery_service interfaces.IUserRecoveryService
}

@[params]
pub struct WsConfirmationParam {
pub:
	hrecovery_service interfaces.IUserRecoveryService
}

pub fn WsConfirmation.new(param WsConfirmationParam) &WsConfirmation {
	return &WsConfirmation{
		hrecovery_service: param.hrecovery_service
	}
}