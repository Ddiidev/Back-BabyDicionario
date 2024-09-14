module implementations

import net.http
import infra.config.repository.service as config_service

pub struct StorageBabydi {}

const endpoint_create_user = 'user'

pub fn (s StorageBabydi) create_user(uuid string) ! {
	config := config_service.get()
	api := config.get_api_storage_babydi()!
	endpoint := '${api}/${implementations.endpoint_create_user}/${uuid}'

	res := http.post(endpoint, '')!

	if res.status_code != 200 {
		return error_with_code(res.body, res.status_code)
	}
}
