module implementations

import infra.profiles.entities
import infra.connection

pub struct ProfileRepository {}

pub fn (p ProfileRepository) get_profile(uuid string) entities.Profile {
	db, close := connection.get()

	defer {
		close() or {}
	}

	profiles := sql db {
		select from entities.Profile where uuid == uuid
	} or { []entities.Profile{} }

	return profiles.first()
}

pub fn (p ProfileRepository) get_profile_by_suuid(suuid string, name_shared_link string) !entities.Profile {
	db, close := connection.get()

	defer {
		close() or {}
	}

	profiles := sql db {
		select from entities.Profile where short_uuid == suuid && name_shared_link == name_shared_link
	} or { []entities.Profile{} }

	return if profiles.len > 0 {
		profiles.first()
	} else {
		return error('Perfil não encontrado')
	}
}

pub fn (p ProfileRepository) get_profiles_by_id(id int) []entities.Profile {
	db, close := connection.get()

	defer {
		close() or {}
	}

	profiles := sql db {
		select from entities.Profile where id == id
	} or { []entities.Profile{} }

	return profiles
}

pub fn (p ProfileRepository) get_profiles_irmaos(profile_required_id int, father_id int, mother_id int) []entities.Profile {
	db, close := connection.get()

	defer {
		close() or {}
	}

	profiles := sql db {
		select from entities.Profile where id != profile_required_id
		&& (father_id == father_id || mother_id == mother_id)
	} or { []entities.Profile{} }

	return profiles
}
