module errors

pub struct UserInvalid {
	Error
pub:
	msg string
}

pub fn (u UserInvalid) msg() string {
	return u.msg
}
