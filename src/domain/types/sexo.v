module types

@[json_as_number]
pub enum Sex {
	masculino = 0
	feminino  = 1
}

pub fn (s Sex) to_int() int {
	return int(s)
}

pub fn Sex.to_sex(s int) Sex {
	return unsafe { Sex(s) }
}
