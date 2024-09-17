module types

@[json_as_number]
pub enum Responsible as i8 {
	is_not_responsible = -1
	pai                = 0
	mae                = 1
}

pub fn (r Responsible) to_i8() ?i8 {
	return ?i8(r)
}

pub fn Responsible.to_responsible(r ?i8) ?Responsible {
	return unsafe {
		if r == none {
			none
		} else {
			Responsible(r?)
		}
	}
}
