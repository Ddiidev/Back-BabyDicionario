module word

import x.vweb
import api.ws_context
import domain.word.interfaces

@[noinit]
pub struct WsWord {
	vweb.Middleware[ws_context.Context]
	hword_service interfaces.IWordService
}

@[params]
pub struct WsWordParam {
pub:
	hword_service interfaces.IWordService
}

pub fn WsWord.new(param WsWordParam) &WsWord {
	return &WsWord{
		hword_service: param.hword_service
	}
}