module confirmation

import api.ws_context
import x.vweb

pub struct WsConfirmation {
	vweb.Middleware[ws_context.Context]
}
