module user

import domain.user.application_services as domain_user_appservices
import api.ws_context
import x.vweb

@['/block/:access_token']
pub fn (ws &WsUser) block_user(mut ctx ws_context.Context, access_token string) vweb.Result {
	success_htmlpage := domain_user_appservices.block_user(access_token) or {
		return ctx.html(err.msg())
	}
	
	return ctx.html(success_htmlpage)
}
