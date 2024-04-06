module interfaces

import domain.user.contracts

pub interface IUserRecoveryService {
	recover_password(contract contracts.RecoveryPassword) !
}
