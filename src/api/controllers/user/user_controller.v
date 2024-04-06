module user

import domain.user.interfaces
import api.ws_context
import x.vweb

pub struct WsUser {
	vweb.Middleware[ws_context.Context]
	huser_service interfaces.IUserService
	huser_confirmation_service interfaces.IUserConfirmationService
}
