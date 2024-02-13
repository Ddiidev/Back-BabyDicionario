module connection

import db.sqlite
import orm

const path_db = $env('BABYDI_PATH_DB')

pub fn get() orm.Connection {
	return sqlite.connect(path_db) or {
		panic('fail connection db | path: "${path_db}"')
	}
}