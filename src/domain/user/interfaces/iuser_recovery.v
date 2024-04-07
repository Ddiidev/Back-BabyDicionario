module interfaces

import domain.user.contracts
import domain.types

pub interface IUserRecoveryService {
	redefined_password(contract contracts.RecoveryPassword) !
	begin_recover_password(contract contracts.ContractUser) !(!types.AccessToken)
}
