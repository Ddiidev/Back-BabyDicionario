module user

fn body_msg_confirmation_html(nome_usuario string, codigo_confirmacao string) string {
	email_dicionario_baby := $env('BABYDI_SMTP_EMAIL_FROM_SUPORT')
	return $tmpl('msg_confirmacao.html')
}
