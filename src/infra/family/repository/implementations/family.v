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
