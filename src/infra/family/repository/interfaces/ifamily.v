module interfaces

import infra.family.entities

pub interface IFamilyRepository {
	get_by_father(uuid string) !entities.Family
	get_by_mother(uuid string) !entities.Family
	get_by_user(uuid string) !entities.Family
	get_by_id(id int) !entities.Family
	create(family entities.Family) !int

	// update_by_id Atualiza o perfil correspondente que estiver com o profile do objeto preenchido com base do id do objeto
	update_by_id(family entities.Family) !
}
