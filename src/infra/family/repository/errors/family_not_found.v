module errors

pub struct FamilyNotFound {
	Error
}

const msg_family_not_found = 'Famíli não encontrada'

@[inline]
pub fn (f FamilyNotFound) msg() string {
	return msg_family_not_found
}