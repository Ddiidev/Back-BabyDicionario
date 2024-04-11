module errors

const msg_err_user_blocked = 'O usuário está atualmente bloqueado, para conseguir acessar a conta tente uma recuperação ou envie email para o suporte'

pub struct UserErrorUserBlockedInvaild {
	Error
}

pub fn (u UserErrorUserBlockedInvaild) msg() string {
	return errors.msg_err_user_blocked
}
