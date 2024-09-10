module implementations

import ken0x0a.dotenv

pub struct Config {}

fn (_ &Config) get_api_storage_babydi() !string {
	return $if dev ? {
		local_env := dotenv.parse('.env.local')

		storage_host := local_env['BABYDI_STORAGE_HOST'] or {
			return error('Env var BABYDI_STORAGE_HOST not found')
		}
		storage_port := local_env['BABYDI_STORAGE_PORT'] or {
			return error('Env var BABYDI_STORAGE_PORT not found')
		}

		'${storage_host.trim_space()}:${storage_port.trim_space()}'
	} $else {
		storage_host := $env('BABYDI_STORAGE_HOST')
		storage_port := $env('BABYDI_STORAGE_PORT')

		'${storage_host.trim_space()}:${storage_port.trim_space()}'
	}
}
