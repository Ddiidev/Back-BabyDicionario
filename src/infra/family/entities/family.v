module entities

@[table: 'families']
pub struct Family {
pub:
	id                  ?int    @[primary; sql: serial]
	user_uuid_father    ?string
	profile_uuid_father ?int
	user_uuid_mother    ?string
	profile_uuid_mother ?int
}
