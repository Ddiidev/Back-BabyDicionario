module user

import api.ws_context
import x.vweb

pub struct WsUser {
	vweb.Middleware[ws_context.Context]
}
