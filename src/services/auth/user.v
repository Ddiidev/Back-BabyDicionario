module auth

import x.vweb
import services.ws_context { Context }
import json
import jwt
import rand

pub struct WsAuth {}

pub struct Credential {
	user string
	pass string
}

@['/'; post]
pub fn (a &WsAuth) user_auth(mut ctx Context) vweb.Result {
	body := ctx.req.data

	credential := json.decode(Credential, body) or { Credential{} }

	payload := jwt.Payload[Credential]{
		sub: '1234567890'
		ext: credential
	}
	token := jwt.Token.new(payload, $env('BABYDI_SECRETKEY'))

	return ctx.json({
		'access_token':  token.str()
		'refresh_token': rand.uuid_v4()
	})
}

@['/refresh'; post]
pub fn (a &WsAuth) user_refresh_token(mut ctx Context) vweb.Result {
	// ctx.form['refresh_token']
	// credential := json.decode(Credential, body) or {
	// 	Credential{}
	// }

	// payload := jwt.Payload[Credential]{
	// 	sub: "1234567890",
	// 	ext: credential
	// }
	// token := jwt.Token.new(payload, $env("BABYDI_SECRETKEY"))
	return ctx.text('not implemented')
}
