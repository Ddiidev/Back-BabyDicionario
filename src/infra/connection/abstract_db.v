module connection

import db.sqlite
import db.pg

pub type AbstractDB = pg.DB | sqlite.DB

pub type AbstractRow = pg.Row | sqlite.Row

pub fn (row AbstractRow) vals() []?string {
	match row {
		sqlite.Row {
			return row.vals.map(?string(it))
		}
		pg.Row {
			return row.vals
		}
	}
}

pub struct QueryParameter {
pub:
	query string
	params []string
}

pub fn (abdb AbstractDB) prepare(query string, params [][]string) QueryParameter {
	mut values := []string{}
	mut parameters := []string{}
	mut count := 0
	value_param := fn [mut count, abdb] () string {
		match abdb {
			sqlite.DB {
				return '?'
			}
			pg.DB {
				count++
				return '\$${count}'
			}
		}
	}

	if params.len == 0 {
		return QueryParameter{query, values}
	}

	for param in params {
		if param.len  != 2 {
			return QueryParameter{query, values}
		}

		parameters << "${param[0]} = ${value_param()}"
		values << param[1]
	}

	return QueryParameter{'${query} ${parameters.join(',')}', values}
}

pub fn (mut abdb AbstractDB) close() ! {
	match mut abdb {
		sqlite.DB {
			abdb.close()!
		}
		pg.DB {
			abdb.close()
		}
	}
}

pub fn (mut abdb AbstractDB) exec_param_many(query string, params []string) ![]AbstractRow {
	match mut abdb {
		sqlite.DB {
			return abdb.exec_param_many(query, params)!.map(AbstractRow(it))
		}
		pg.DB {
			return abdb.exec_param_many(query, params)!.map(AbstractRow(it))
		}
	}
}