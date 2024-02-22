module errors

pub struct InvalidCode {
	Error
}

pub fn (err InvalidCode) msg() string {
	return 'Código inválido'
}