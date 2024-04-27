module services

import domain.profile.models
import infra.family.repository.service as repo_family_service
import infra.family.adapters as adapter_family

pub struct FamilyService {}

pub fn (f FamilyService) create(family models.Family) !int {
	repo_family := repo_family_service.get()	
	
	family_id := repo_family.create(adapter_family.model_to_entitie(family))!

	return family_id
}