module interfaces

pub interface IEmail {
	send(to string, subject string, body string) !
}
