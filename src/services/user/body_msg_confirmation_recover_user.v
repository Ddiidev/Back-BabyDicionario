module user

pub fn body_msg_confirmation_recover_user(code string) string {
	email_dicionario_baby := $env('BABYDI_SMTP_EMAIL_FROM')
	return $tmpl('msg_confirmation_recover_user.html')	
}