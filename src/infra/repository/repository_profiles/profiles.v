module repository_profiles

import infra.entities
import infra.connection

pub fn get_profile(uuid string) entities.Profile {
	db, close := connection.get()

	defer {
		close() or {}
	}

	profiles := sql db {
		select from entities.Profile where uuid == uuid
	} or { [entities.Profile{}] }

	return profiles.first()
}

pub fn get_profile_by_suuid(suuid string, name_shared_link string) !entities.Profile {
	db, close := connection.get()

	defer {
		close() or {}
	}

	profiles := sql db {
		select from entities.Profile where short_uuid == suuid && name_shared_link == name_shared_link
	} or { [entities.Profile{}] }

	return if profiles.len > 0 {
		profiles.first()
	} else {
		return error('Perfil não encontrado')
	}
}

pub fn get_profiles_by_id(id int) []entities.Profile {
	db, close := connection.get()

	defer {
		close() or {}
	}

	profiles := sql db {
		select from entities.Profile where id == id
	} or { [entities.Profile{}] }

	return profiles
}

pub fn get_profiles_irmaos(profile_required_id int, pai_id int, mae_id int) []entities.Profile {
	db, close := connection.get()

	defer {
		close() or {}
	}

	profiles := sql db {
		select from entities.Profile where id != profile_required_id
		&& (pai_id == pai_id || mae_id == mae_id)
	} or { [entities.Profile{}] }

	return profiles
}
