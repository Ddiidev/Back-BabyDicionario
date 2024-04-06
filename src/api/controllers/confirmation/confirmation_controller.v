module confirmation

import domain.user.interfaces
import api.ws_context
import x.vweb

pub struct WsConfirmation {
	vweb.Middleware[ws_context.Context]
	hrecovery_service interfaces.IUserRecoveryService
}
