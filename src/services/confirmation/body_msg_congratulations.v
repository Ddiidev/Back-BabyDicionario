module confirmation

fn body_msg_congratulations_html(nome_usuario string) string {
	email_dicionario_baby := $env('BABYDI_SMTP_EMAIL_FROM')
	return $tmpl('msg_congratulations.html')
}
