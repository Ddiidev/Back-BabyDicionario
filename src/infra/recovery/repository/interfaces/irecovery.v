module interfaces

import infra.recovery.entities

pub interface IRecoveryRepository {
	delete(email string) !
	create(recover entities.UserRecovery) !
	get_by_email(email string) !entities.UserRecovery
	email_contains_pendenting_recovery_password(email string) bool
	get_by_token(access_token string) !entities.UserRecovery
}
