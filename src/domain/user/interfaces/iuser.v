module interfaces

import domain.user.models
import domain.user.contracts

pub interface IUserService {
	login(email string, password string) !contracts.TokenContract
	create(user models.User) !models.User
	// Retorna os detalhes do usuário
	details(user_uuid string) !models.User
	// Remove o usuário temporário caso o usuário tenha confirmado sua conta.
	delete_temporary_user_if_confirmed_user_exists(user_uuid string) !
	// Verifica se o usuário existe
	contain(uuid string) bool
}
