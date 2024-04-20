module service

import infra.family.repository.interfaces
import infra.family.repository.implementations

pub fn get() interfaces.IFamilyRepository {
	return implementations.FamilyRepository{}
}
