module models

pub struct None {}

pub type ProfileAlias = ?None | Profile

pub fn ProfileAlias.new() ProfileAlias {
	return ProfileAlias(?None{})
}