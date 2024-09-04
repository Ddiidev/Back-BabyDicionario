module types

@[json_as_number]
pub enum Sex as i8 {
	masculino = 0
	feminino  = 1
}

pub fn (s Sex) to_i8() i8 {
	return i8(s)
}

pub fn Sex.from_i8(s i8) Sex {
	return unsafe { Sex(s) }
}
