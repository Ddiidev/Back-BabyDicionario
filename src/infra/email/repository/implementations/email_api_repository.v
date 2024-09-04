module implementations

import net.http
import json

pub struct EmailApiRepository {}

const url = 'https://api.brevo.com/v3/smtp/email'

pub fn (e EmailApiRepository) send(to string, subject string, body string) ! {
	dump($env('BABYDI_SMTP_PASSWORD'))
	data := json.encode(EmailJsonContract{
		subject:      subject
		html_content: body
		to:           [
			To{
				email: to
			},
		]
		sender: Sender{
			email: $env('BABYDI_SMTP_EMAIL_FROM')
		}
		reply_to: ReplyTo{
			email: $env('BABYDI_SMTP_EMAIL_FROM')
		}
	})
	http.fetch(http.FetchConfig{
		url:    implementations.url
		method: .post
		header: http.new_custom_header_from_map({
			'api-key': $env('BABYDI_SMTP_PASSWORD')
		})!
		data: data
	})!
}
