module service

import infra.recovery.repository.interfaces
import infra.recovery.repository.implementations

pub fn get() interfaces.IRecoveryRepository {
	return implementations.RecoveryRepository{}
}
