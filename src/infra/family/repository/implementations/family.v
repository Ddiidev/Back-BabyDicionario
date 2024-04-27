module implementations

import infra.connection
import infra.family.entities
import infra.family.repository.errors

pub struct FamilyRepository {}

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

	$dbg;

	sql conn {
		insert family into entities.Family
	}!

	
	family_ := f.get(family)!
	

	return family_.id or {-1}
}

fn (f FamilyRepository) get(family entities.Family) !entities.Family {
	conn, close := connection.get()

	defer {
		close() or {}
	}

	mut families := []entities.Family{}
	match family.get_reponsible() {
		.pai {
			families = sql conn {
				select from entities.Family where profile_uuid_father == family.profile_uuid_father limit 1
			} or {
				println(err)
				return err
			}
		}
		.mae {
			families = sql conn {
				select from entities.Family where profile_uuid_mother == family.profile_uuid_mother limit 1
			} or {
				println(err)
				return err
			}
		}
	}
	$dbg;

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
