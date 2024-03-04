module auth

import encoding.base64
import crypto.sha256
import crypto.hmac
import rand

// gen_pasword Gera uma senha criptografada
pub fn gen_password(pass string) string {
	singnature := hmac.new($env('BABYDI_SECRETKEY').bytes(), pass.bytes(), sha256.sum,
		sha256.block_size)
	return base64.encode(singnature)
}

// random_number Gera um uma string contendo 6 número pseudo-aleatório
pub fn random_number() string {
	res := rand.i64_in_range(111111, 999999) or { rand.int63() }.str().limit(6)
	return res
}