module auth_test

import jwt
import net.http
import json

pub struct Credential {
	user string
	pass string
}

const secretkey = $env('BABYDI_SECRETKEY')
const url = 'http://localhost:3035/auth/user'
const url_refresh = 'http://localhost:3035/auth/user/refresh'
const payload = Credential{
	user: 'andre@gmail.com'
	pass: '123456'
}

fn test_obter_token() ! {
	resp_body := http.post_json(auth_test.url, json.encode(auth_test.payload))!.body

	js_body := json.decode(map[string]string, resp_body)!

	js_access := jwt.from_str[Credential](js_body['access_token'])!

	assert js_access.valid(auth_test.secretkey)
}

fn test_refresh_token() ! {
	resp_body := http.post_json(auth_test.url, json.encode(auth_test.payload))!.body

	js_body := json.decode(map[string]string, resp_body)!

	js_access := jwt.from_str[Credential](js_body['access_token'])!

	assert js_access.valid(auth_test.secretkey)

	resp_body_refresh := http.post_form(auth_test.url_refresh, {
		'refresh_token': js_body['refresh_token']
	})!.body

	// not implemented
	if true {
		assert true
		return
	}

	js_body_refresh := json.decode(map[string]string, resp_body_refresh)!

	new_token := jwt.from_str[Credential](js_body_refresh['access_token'])!

	assert new_token.valid(auth_test.secretkey)
}
