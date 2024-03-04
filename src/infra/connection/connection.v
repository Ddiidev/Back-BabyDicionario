module connection

import infra.entities
import db.sqlite
import orm

const path_db = $env('BABYDI_PATH_DB')

fn init() {
	conn, close := get()

	defer {
		close() or {}
	}

	sql conn {
		create table entities.UserRecovery
		create table entities.UserTemp
		create table entities.Profile
		create table entities.Token
		create table entities.Word
		create table entities.User
	} or { panic('fail create table | ${err}') }
}

pub fn get() (orm.Connection, fn () !bool) {
	conn := sqlite.connect(connection.path_db) or {
		panic('fail connection db | path: "${connection.path_db}"')
	}

	return conn, conn.close
}

pub fn get_sqlite() sqlite.DB {
	conn := sqlite.connect(connection.path_db) or {
		panic('fail connection db | path: "${connection.path_db}"')
	}

	return conn
}

pub fn get_name_table[T]() !string {
	$for t in T.attributes {
		if t.name == 'table' {
			return t.arg
		}
	}
	return error('Falha ao obter o nome da tabela')
}
