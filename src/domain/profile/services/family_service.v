module services

import domain.profile.models
import infra.family.repository.service as repo_family_service
import infra.family.adapters as adapter_family

pub struct FamilyService {}

pub fn (f FamilyService) create(family models.Family) !int {
	repo_family := repo_family_service.get()	
	
	x := adapter_family.model_to_entitie(family)

	$dbg;
	family_id := repo_family.create(x)!

	return family_id
}