module words

pub struct WordContractResponse {
pub:
	id        int
	palavra   string
	traducao  string
	pronuncia string
	audio     string
}

pub struct WordContractRequest {
pub:
	profile_uuid string
	words        []WordsContractRequest
}

pub struct WordsContractRequest {
pub:
	palavra   string
	traducao  string
	pronuncia string
	audio     string
}
