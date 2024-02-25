module errors_user

pub struct UserInvalid {
	Error
	msg string
}

pub fn (u UserInvalid) msg() string {
	return u.msg
}
