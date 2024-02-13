module profiles

import infra.entities
import infra.connection

pub fn get_profile(uuid string) entities.Profile {
	db := connection.get()

	profiles := sql db {
		select from entities.Profile where uuid == 'b396a08'
	} or {
		[entities.Profile{}]
	}

	return profiles.first()
}

pub fn get_profiles_by_id(id int) []entities.Profile {
	db := connection.get()

	profiles := sql db {
		select from entities.Profile where id == id
	} or {
		[entities.Profile{}]
	}

	return profiles
}

pub fn get_profiles_irmaos(profile_required_id int, pai_id int, mae_id int) []entities.Profile {
	db := connection.get()

	profiles := sql db {
		select from entities.Profile where id != profile_required_id && (pai_id == pai_id || mae_id == mae_id)
	} or {
		[entities.Profile{}]
	}

	return profiles
}