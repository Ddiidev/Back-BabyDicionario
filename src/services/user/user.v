module user

import services.ws_context { Context }
import x.vweb

pub struct WsUser {
	vweb.Middleware[Context]
}