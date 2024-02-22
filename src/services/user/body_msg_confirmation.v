module user

fn body_msg_confirmation_html(nome_usuario string, codigo_confirmacao string) string {
	return $tmpl('msg_confirmacao.html')
}
