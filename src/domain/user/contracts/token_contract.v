module contracts

@[noinit]
pub struct TokenContract {
pub:
	access_token  string
	refresh_token string
}

@[minify; params]
pub struct TokenContractParam {
pub:
	access_token  string
	refresh_token string
}

pub fn TokenContract.new(param TokenContractParam) ?TokenContract {
	return if param.access_token.trim_space() == '' || param.refresh_token.trim_space() == '' {
		none
	} else {
		TokenContract{
			access_token:  param.access_token
			refresh_token: param.refresh_token
		}
	}
}
