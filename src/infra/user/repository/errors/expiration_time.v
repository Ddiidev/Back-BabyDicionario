module errors

pub struct ExpirationTime{
	Error
}

pub fn (err ExpirationTime) msg() string {
	return 'O código de ativação expirou!\nVocê pode iniciar um novo cadastro para obter um novo código de ativação.'
}