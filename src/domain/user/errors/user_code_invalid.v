module errors

pub struct UserErrorCodeInvaild {
	Error
}

pub fn (u UserErrorCodeInvaild) msg() string {
	return "Código inválido"
}