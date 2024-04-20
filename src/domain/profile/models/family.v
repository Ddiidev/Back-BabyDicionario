module models

import domain.types

@[noinit]
pub struct Family {
pub:
	id                ?int
	user_uuid_father  ?string
	profile_id_father ?int
	user_uuid_mother  ?string
	profile_id_mother ?int
}

pub fn Family.new(uuid string, user_id int, responsible types.Responsible) Family {
	match responsible {
		.pai {
			return Family{
				user_uuid_father: uuid
				profile_id_father: user_id
			}
		}
		.mae {
			return Family{
				user_uuid_mother: uuid
				profile_id_mother: user_id
			}
		}
	}
}
