module interfaces

pub interface IEmail {
	send(to string, body string, subject string) !
}
