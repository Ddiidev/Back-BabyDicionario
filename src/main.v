module main

import x.vweb
import services.ws_context { Context }
import services.auth
import services.profile

pub struct Wservice {
	vweb.Controller
}

pub fn (ws &Wservice) index(mut ctx Context) vweb.Result {
	return ctx.text('teste index')
}

fn main() {
	mut ws := &Wservice{}
	mut ws_user_auth := &auth.WsAuth{}
	mut ws_profile := &profile.WsProfile{}

	//temporário
	ws_profile.use(vweb.cors[Context](vweb.CorsOptions{
		origins: ['*']
		allowed_methods: [.get, .head, .options, .patch, .put, .post, .delete]
	}))

	ws.register_controller[auth.WsAuth, Context]('/auth/user', mut ws_user_auth)!
	ws.register_controller[profile.WsProfile, Context]('/profile', mut ws_profile)!


	vweb.run[Wservice, Context](mut ws, 3035)
}
