module errors

pub struct NoExistUser {
	Error
}

pub fn (err NoExistUser) msg() string {
	return 'Não foi encontrado este usuário.'
}
