module implementations

import domain.types
import infra.profile.entities
import infra.connection
import time

pub struct ProfileRepository {}

pub fn (p ProfileRepository) update_family_id(uuid string, family_id int) ! {
	db, close := connection.get()

	defer {
		close() or {}
	}

	sql db {
		update entities.Profile set family_id = family_id where uuid == uuid
	} or { return error('Falha ao atualizar perfil') }
}

pub fn (p ProfileRepository) update(profile entities.Profile) ! {
	db, close := connection.get()

	defer {
		close() or {}
	}

	sql db {
		update entities.Profile set name_shared_link = profile.name_shared_link, surname = profile.surname,
		first_name = profile.first_name, last_name = profile.last_name, birth_date = profile.birth_date,
		weight = profile.weight, sex = profile.sex, color = profile.color, updated_at = time.utc(),
		height = profile.height where uuid == profile.uuid
	} or { return error('Falha ao atualizar perfil') }
}

pub fn (p ProfileRepository) create(profile entities.Profile) ! {
	db, close := connection.get()

	defer {
		close() or {}
	}

	sql db {
		insert profile into entities.Profile
	}!
}

pub fn (p ProfileRepository) get_profile(uuid string) ?entities.Profile {
	db, close := connection.get()

	defer {
		close() or {}
	}

	profiles := sql db {
		select from entities.Profile where uuid == uuid
	} or { return none }

	return profiles[0] or { none }
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
		profiles[0]
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

pub fn (p ProfileRepository) get_profiles_brothers(family_id int) []entities.Profile {
	db, close := connection.get()

	defer {
		close() or {}
	}

	baby_responsible := i8(types.Responsible.is_not_responsible)

	profiles := sql db {
		select from entities.Profile where family_id == family_id && responsible == baby_responsible
	} or { []entities.Profile{} }

	return profiles
}
