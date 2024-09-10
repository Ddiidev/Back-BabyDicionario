module user

import veb
import api.ws_context
import domain.user.services as user_service

@['/contain/:uuid']
fn (ws &WsUser) contain(mut ctx ws_context.Context, uuid string) veb.Result {
	huser := user_service.get_user()

	if !huser.contain(uuid) {
		ctx.res.set_status(.not_found)
		ctx.json({
			'message': 'Usuário não encontrado.'
			'status':  'error'
		})
	}

	return ctx.json({
		'message': 'OK'
		'status':  'info'
	}) // 200 OK
}
