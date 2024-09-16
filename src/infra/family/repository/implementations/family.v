module implementations

import utils
import infra.connection
import infra.family.entities
import infra.family.repository.errors

pub struct FamilyRepository {}

// get_by_user obtém family com base no uuid do usuário que pode ser do pai ou da mãe.
pub fn (f FamilyRepository) get_by_user(uuid string) !entities.Family {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	families := sql conn {
		select from entities.Family where user_uuid_father == uuid || user_uuid_mother == uuid limit 1
	}!

	if families.len == 1 {
		return families[0]
	}

	return errors.FamilyNotFound{}
}

pub fn (f FamilyRepository) get_by_father(uuid string) !entities.Family {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	families := sql conn {
		select from entities.Family where user_uuid_father == uuid limit 1
	}!

	if families.len == 1 {
		return families[0]
	}

	return errors.FamilyNotFound{}
}

pub fn (f FamilyRepository) get_by_mother(uuid string) !entities.Family {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	families := sql conn {
		select from entities.Family where user_uuid_mother == uuid limit 1
	}!

	if families.len == 1 {
		return families[0]
	}

	return errors.FamilyNotFound{}
}

pub fn (f FamilyRepository) create(family entities.Family) !int {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	sql conn {
		insert family into entities.Family
	}!

	family_ := f.get(family)!

	return family_.id or { -1 }
}

fn (f FamilyRepository) get(family entities.Family) !entities.Family {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	mut families := []entities.Family{}

	match family.get_reponsible() {
		.pai {
			profile_uuid_father := family.profile_uuid_father or { return errors.FamilyNotFound{} }

			families = sql conn {
				select from entities.Family where profile_uuid_father == profile_uuid_father limit 1
			} or {
				println(err)
				return err
			}
		}
		.mae {
			profile_uuid_mother := family.profile_uuid_mother or { return errors.FamilyNotFound{} }

			families = sql conn {
				select from entities.Family where profile_uuid_mother == profile_uuid_mother limit 1
			} or {
				println(err)
				return err
			}
		}
		.is_not_responsible {
			return errors.FamilyImpossibleFoundWithoutResponsible{}
		}
	}

	if families.len == 1 {
		return families[0]
	}

	return errors.FamilyNotFound{}
}

pub fn (f FamilyRepository) get_by_id(id int) !entities.Family {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	families := sql conn {
		select from entities.Family where id == id limit 1
	}!

	if families.len == 1 {
		return families[0]
	}

	return errors.FamilyNotFound{}
}

// update_by_id Atualiza o perfil correspondente que estiver com o profile do objeto preenchido com base do id do objeto
pub fn (f FamilyRepository) update_by_id(family entities.Family) ! {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	is_father := utils.is_valid_uuid(family.profile_uuid_father)
	is_mother := utils.is_valid_uuid(family.profile_uuid_mother)

	if is_father && !is_mother {
		sql conn {
			update entities.Family set profile_uuid_father = family.profile_uuid_father where id == family.id
		}!
	} else if is_mother && !is_father {
		sql conn {
			update entities.Family set profile_uuid_mother = family.profile_uuid_mother where id == family.id
		}!
	} else {
		return error('Perfil não especificado')
	}
}
