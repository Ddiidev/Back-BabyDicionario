module interfaces

import domain.profile.models

pub interface IFamilyService {
	create(family models.Family) !int

	// update_by_id Atualiza o perfil correspondente que estiver com o profile do objeto preenchido com base do id do objeto
	update_by_id(family models.Family) !
}
