module implementations

struct EmailJsonContract {
	sender       Sender  @[omitempty]
	to           []To    @[omitempty]
	html_content string  @[json: 'htmlContent'; omitempty]
	subject      string  @[omitempty]
	reply_to     ReplyTo @[json: 'replyTo'; omitempty]
}

struct Sender {
	name  string @[omitempty]
	email string @[omitempty]
}

struct To {
	email string @[omitempty]
	name  string @[omitempty]
}

struct ReplyTo {
	email string @[omitempty]
	name  string @[omitempty]
}
