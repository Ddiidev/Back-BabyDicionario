module entities

@[table: 'family']
pub struct Family {
	id            ?int    @[primary; sql: serial]
	user_uuid_father string
	user_uuid_mother ?string
}
