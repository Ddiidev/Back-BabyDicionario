module contract_api

pub struct ContractApi[T] {
pub:
	message string             @[required]
	status  ?StatusContractApi @[omitempty; required]
	content ?T                 @[omitempty]
}

pub struct ContractApiNoContent {
pub:
	message string             @[required]
	status  ?StatusContractApi @[omitempty; required]
}

pub enum StatusContractApi {
	info
	error
}
