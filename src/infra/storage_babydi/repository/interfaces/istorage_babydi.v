module interfaces

pub interface IStorageBabydi {
	create_user(uuid string) !
	delete_profile(user_uuid string, uuid_profile string) !
}
