module main

import api.controllers.confirmation
import api.controllers.profile
import api.controllers.user
import api.controllers.word
import api.middleware.auth
import api.ws_context
import domain.user.services as user_service
import domain.word.services as word_service
import domain.profile.services as profile_service
import veb

pub struct Wservice {
	veb.Controller
	veb.StaticHandler
}

fn main() {
	mut ws := &Wservice{}
	mut ws_user_auth := &auth.WsAuth{}

	mut ws_user := user.WsUser.new(
		huser_service:              user_service.get_user()
		huser_recovery_service:     user_service.get_user_recovery()
		huser_confirmation_service: user_service.get_user_confirmation()
	)
	mut ws_profile := profile.WsProfile.new(
		hprofile_service: profile_service.get()
	)
	mut ws_confirmation := confirmation.WsConfirmation.new(
		hrecovery_service: user_service.get_user_recovery()
	)
	mut ws_word := word.WsWord.new(
		hword_service: word_service.get()
	)

	// temporário
	conf_cors := veb.cors[ws_context.Context](veb.CorsOptions{
		origins:         ['*']
		allowed_methods: [.get, .head, .options, .patch, .put, .post, .delete]
	})
	ws_user_auth.use(conf_cors)
	ws_profile.use(conf_cors)
	ws_confirmation.use(conf_cors)
	ws_user.use(conf_cors)
	ws_word.use(conf_cors)
	
	/**
	 * Middleware para compressão de dados
	*/
	ws_user_auth.use(veb.encode_gzip[ws_context.Context]())
	ws_user.use(veb.encode_gzip[ws_context.Context]())
	ws_word.use(veb.encode_gzip[ws_context.Context]())
	ws_confirmation.use(veb.encode_gzip[ws_context.Context]())
	ws_profile.use(veb.encode_gzip[ws_context.Context]())

	
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

	veb.run[Wservice, ws_context.Context](mut ws, 3035)
}
