module connection

import infra.profile.entities as profiles_entities
import infra.recovery.entities as recovery_entities
import infra.word.entities as words_entities
import infra.token.entities as token_entities
import infra.user.entities as user_entities
import infra.family.entities as family_entities
import ken0x0a.dotenv
import db.pg

const path_db = $env('BABYDI_PATH_DB')

fn init() {
	conn := get()

	defer {
		conn.close()
	}

	sql conn {
		create table recovery_entities.UserRecovery
		create table user_entities.UserTemp
		create table profiles_entities.Profile
		create table family_entities.Family
		create table token_entities.Token
		create table words_entities.Word
		create table user_entities.User
	} or { panic('fail create table | ${err}') }
}

pub fn get() pg.DB {
	local_env := dotenv.parse('.env.local')

	conf := pg.Config{
		host:     local_env['BABYDI_HOST_DB']
		port:     local_env['BABYDI_PORT_DB'].int()
		user:     local_env['BABYDI_USER_DB']
		password: local_env['BABYDI_PASS_DB']
		dbname:   local_env['BABYDI_DBNAME_DB']
	}

	conn := pg.connect(conf) or { panic(err) }

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
