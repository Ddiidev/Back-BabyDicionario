module ext_services

pub fn body_msg_confirmation_html(user_name string, code_confirmation string) string {
	email_dicionario_baby := $env('BABYDI_SMTP_EMAIL_FROM_SUPORT')
	return $tmpl('msg_confirmacao.html')
}
