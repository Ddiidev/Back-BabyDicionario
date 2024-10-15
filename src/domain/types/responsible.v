module types

@[json_as_number]
pub enum Responsible {
	is_not_responsible = -1
	pai                = 0
	mae                = 1
}

pub fn (r Responsible) to_int() ?int {
	return ?int(r)
}

pub fn Responsible.to_responsible(r ?int) ?Responsible {
	return unsafe {
		if r == none {
			none
		} else {
			Responsible(r)
		}
	}
}
