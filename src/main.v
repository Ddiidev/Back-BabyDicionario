module main

import api.controllers.confirmation
import api.controllers.profile
import api.controllers.user
import api.controllers.word
import api.middleware.auth
import api.ws_context
import x.vweb

pub struct Wservice {
	vweb.Controller
	vweb.StaticHandler
}


fn main() {
	mut ws := &Wservice{}
	mut ws_user := &user.WsUser{}
	mut ws_user_auth := &auth.WsAuth{}
	mut ws_profile := &profile.WsProfile{}
	mut ws_confirmation := &confirmation.WsConfirmation{}
	mut ws_word := &word.WsWord{}

	// temporário
	conf_cors := vweb.cors[ws_context.Context](vweb.CorsOptions{
		origins: ['*']
		allowed_methods: [.get, .head, .options, .patch, .put, .post, .delete]
	})
	ws_user_auth.use(conf_cors)
	ws_profile.use(conf_cors)
	ws_confirmation.use(conf_cors)
	ws_user.use(conf_cors)
	ws_word.use(conf_cors)
	// ws_word.route_use('/', handler: auth.authenticate)
	ws_profile.route_use('/:...', handler: auth.authenticate)
	ws_confirmation.route_use('/recover-password', handler: auth.authenticate_recover_password)

	ws.register_controller[confirmation.WsConfirmation, ws_context.Context]('/confirmation', mut
		ws_confirmation)!
	ws.register_controller[auth.WsAuth, ws_context.Context]('/auth', mut ws_user_auth)!
	ws.register_controller[profile.WsProfile, ws_context.Context]('/profile', mut ws_profile)!
	ws.register_controller[user.WsUser, ws_context.Context]('/user', mut ws_user)!
	ws.register_controller[word.WsWord, ws_context.Context]('/words', mut ws_word)!

	ws.mount_static_folder_at('src/assets', '/assets')!

	vweb.run[Wservice, ws_context.Context](mut ws, 3035)
}
