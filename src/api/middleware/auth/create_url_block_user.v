module auth

pub fn create_url_block(access_token string) string {
	url := $env('BABYDI_DOMAIN')
	return '${url}/user/block/${access_token}'
}
