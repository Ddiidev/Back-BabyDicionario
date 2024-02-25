module auth

import crypto.hmac
import crypto.sha256
import encoding.base64

pub fn gen_password(pass string) string {
	singnature := hmac.new($env('BABYDI_SECRETKEY').bytes(), pass.bytes(), sha256.sum,
		sha256.block_size)
	return base64.encode(singnature)
}
