module interfaces

pub interface IEmail {
	to      string
	body    string
	subject string
	send() !
}
