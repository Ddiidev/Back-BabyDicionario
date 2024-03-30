module connection

import ken0x0a.dotenv
import infra.entities
import infra.words.entities as words_entities
import infra.profiles.entities as profiles_entities
import infra.recovery.entities as recovery_entities
import db.sqlite
import db.pg
import orm

const path_db = $env('BABYDI_PATH_DB')

fn init() {
	conn, close := get()

	defer {
		close() or {}
	}

	sql conn {
		create table recovery_entities.UserRecovery
		create table entities.UserTemp
		create table profiles_entities.Profile
		create table entities.Family
		create table entities.Token
		create table words_entities.Word
		create table entities.User
	} or { panic('fail create table | ${err}') }
}

pub fn get() (orm.Connection, fn () !bool) {
	$if dev? {
		conn := sqlite.connect(connection.path_db) or {
			panic('fail connection db | path: "${connection.path_db}"')
		}
	
		return conn, conn.close
	} $else {
		local_env := dotenv.parse('.env.local')

		conf := pg.Config {
			host:     local_env['BABYDI_HOST_DB']
			port:     local_env['BABYDI_PORT_DB'].int()
			user:     local_env['BABYDI_USER_DB']
			password: local_env['BABYDI_PASS_DB']
			dbname:   local_env['BABYDI_DBNAME_DB']
		}

		conn := pg.connect(conf) or {
			panic(err)
		}
		
		return conn, fn [conn] () !bool {
			conn.close()
			return true
		}
	}
}

pub fn get_db() AbstractDB {
	$if dev? {
		conn := sqlite.connect(connection.path_db) or {
			panic('fail connection db | path: "${connection.path_db}"')
		}
		
		return conn
	} $else {
		local_env := dotenv.parse('.env.local')

		conf := pg.Config {
			host:     local_env['BABYDI_HOST_DB']
			port:     local_env['BABYDI_PORT_DB'].int()
			user:     local_env['BABYDI_USER_DB']
			password: local_env['BABYDI_PASS_DB']
			dbname:   local_env['BABYDI_DBNAME_DB']
		}

		conn := pg.connect(conf) or {
			panic(err)
		}
		
		return conn
	}

}

pub fn get_name_table[T]() !string {
	$for t in T.attributes {
		if t.name == 'table' {
			return t.arg
		}
	}
	return error('Falha ao obter o nome da tabela')
}
