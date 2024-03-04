module errors

pub struct RecoveryNoExist {
	Error
}

pub fn (rne RecoveryNoExist) msg() string {
	return 'Solicitação de recuperação não encontrada.'
}