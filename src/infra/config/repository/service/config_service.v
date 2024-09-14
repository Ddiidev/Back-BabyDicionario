module service

import infra.config.repository.implementations
import infra.config.repository.interfaces

pub fn get() interfaces.IConfig {
	return implementations.Config{}
}
