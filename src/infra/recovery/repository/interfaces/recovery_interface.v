module interfaces

import infra.recovery.entities

pub interface IRecoveryRepository {
	delete(email string) !
	new_recovery_password(recover entities.UserRecovery) !
	get_recovery_password(email string) !entities.UserRecovery
	email_contains_pendenting_recovery_password(email string) bool
	get_recovery_password_by_token(access_token string) !entities.UserRecovery
}