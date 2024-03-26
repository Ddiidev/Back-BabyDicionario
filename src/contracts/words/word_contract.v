module words

pub struct WordContractResponse {
pub:
	id            int
	word          string
	translation    string
	pronunciation string
	audio         string
}

pub struct WordContractRequest {
pub:
	profile_uuid string
	words        []WordsContractRequest
}

pub struct WordsContractRequest {
pub:
	word          string
	translation   string
	pronunciation string
	audio         string
}
