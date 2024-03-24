module entities

@[table: 'family']
pub struct Family {
	id            ?int    @[primary; sql: serial]
	user_uuid_pai string
	user_uuid_mae ?string
}
