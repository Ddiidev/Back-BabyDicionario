module errors

pub struct UserErrorNotFoundDetailsUser {
	Error
}

const user_detail_not_found = "Usuário não foram encontrados"

pub fn (u UserErrorNotFoundDetailsUser) msg() string {
	return user_detail_not_found
}