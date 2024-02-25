module confirmation

import contracts.contract_shared { Responsavel, JsTime }

pub struct ContractEmail {
pub:
	primeiro_nome   string
	responsavel     Responsavel
	data_nascimento JsTime
	email           string
	senha           string
}
