module confirmation

import contracts.contract_shared { JsTime, Responsavel }

pub struct ContractEmail {
pub:
	primeiro_nome   string
	responsavel     Responsavel
	data_nascimento JsTime
	email           string
	senha           string
}
