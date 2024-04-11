module errors

const msg_err_email_or_pass_invalid = 'Email ou senha estão incorretos.'

pub struct UserErrorEmailOrPasswodInvaild {
	Error
}

pub fn (u UserErrorEmailOrPasswodInvaild) msg() string {
	return errors.msg_err_email_or_pass_invalid
}
