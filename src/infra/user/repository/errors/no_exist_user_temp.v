module errors

pub struct NoExistUserTemp {
	Error
}

pub fn (err NoExistUserTemp) msg() string {
	return 'Não foi encontrado este usuário.'
}
