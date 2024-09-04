module models

import domain.types

@[noinit]
pub struct Family {
pub:
	id                  ?int
	user_uuid_father    ?string
	profile_uuid_father ?string
	user_uuid_mother    ?string
	profile_uuid_mother ?string
}

pub fn Family.new_profile_with_id(id int, profile_uuid ?string, responsible types.Responsible) !Family {
	if id < 1 {
		return error('Id inválido!')
	}
	match responsible {
		.pai {
			return Family{
				id:                  id
				profile_uuid_father: profile_uuid
			}
		}
		.mae {
			return Family{
				id:                  id
				profile_uuid_mother: profile_uuid
			}
		}
	}
}

pub fn Family.new(id ?int, user_uuid ?string, profile_uuid ?string, responsible types.Responsible) Family {
	match responsible {
		.pai {
			return Family{
				id:                  id
				user_uuid_father:    user_uuid
				profile_uuid_father: profile_uuid
			}
		}
		.mae {
			return Family{
				id:                  id
				user_uuid_mother:    user_uuid
				profile_uuid_mother: profile_uuid
			}
		}
	}
}

pub fn (f Family) get_reponsible() types.Responsible {
	return match true {
		f.profile_uuid_father or { '' } != '' && f.user_uuid_father or { '' } != '' {
			.pai
		}
		else {
			.mae
		}
	}
}

pub fn (f Family) get_uuid_user_and_profile() (?string, ?string) {
	match true {
		f.profile_uuid_father or { '' } != '' && f.user_uuid_father or { '' } != '' {
			return f.user_uuid_father, f.profile_uuid_father
		}
		else {
			return f.user_uuid_mother, f.profile_uuid_mother
		}
	}
}
