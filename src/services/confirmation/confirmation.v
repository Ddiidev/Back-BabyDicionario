module confirmation

import services.ws_context { Context }
import x.vweb

pub struct WsConfirmation {
	vweb.Middleware[Context]
}