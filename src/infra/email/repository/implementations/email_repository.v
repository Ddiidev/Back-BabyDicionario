module implementations

import net.smtp

pub struct EmailRepository {}

pub fn (e EmailRepository) send(to string, subject string, body string) ! {
	mailserver := $env('BABYDI_SMTP_SERVER')
	mailport := $env('BABYDI_SMTP_SERVER_PORT').int()
	username := $env('BABYDI_SMTP_USERNAME')
	password := $env('BABYDI_SMTP_PASSWORD')
	client_cfg := smtp.Client{
		server:   mailserver
		from:     $env('BABYDI_SMTP_EMAIL_FROM')
		port:     mailport
		username: username
		password: password
	}
	send_cfg := smtp.Mail{
		to:        to
		from:      $env('BABYDI_SMTP_EMAIL_FROM')
		subject:   subject
		body_type: .html
		body:      body
	}

	mut client := smtp.new_client(client_cfg)!
	client.send(send_cfg)!
}
