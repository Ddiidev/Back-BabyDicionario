module service

import infra.storage_babydi.repository.interfaces
import infra.storage_babydi.repository.implementations

pub fn get() interfaces.IStorageBabydi {
	return implementations.StorageBabydi{}
}