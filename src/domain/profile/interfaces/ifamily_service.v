module interfaces

import domain.profile.models

pub interface IFamilyService {
	create(family models.Family) !
}
