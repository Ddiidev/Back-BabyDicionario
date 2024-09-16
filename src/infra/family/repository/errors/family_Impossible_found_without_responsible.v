module errors

pub struct FamilyImpossibleFoundWithoutResponsible {
	Error
}

const msg_family_impossible_found_without_responsible = 'Family not found by no has responsible.'

@[inline]
pub fn (f FamilyImpossibleFoundWithoutResponsible) msg() string {
	return errors.msg_family_impossible_found_without_responsible
}
