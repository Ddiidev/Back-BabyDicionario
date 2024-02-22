module confirmation

import contracts.contract_shared { Responsavel }

pub struct ContractEmail {
pub:
	primeiro_nome string
	responsavel   Responsavel
	idade         f32
	email         string
	senha         string
}
