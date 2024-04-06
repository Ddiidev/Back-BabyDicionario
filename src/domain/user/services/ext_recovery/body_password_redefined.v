module ext_recovery

import domain.types

// body_password_redefined
// ip	-	IP da página solicitante
// date	-	Data da solicitação
pub fn body_password_redefined(ip string, url_block_user string, date types.JsTime) string {
	email_dicionario_baby := $env('BABYDI_SMTP_EMAIL_FROM_SUPORT')

	return $tmpl('msg_password_redefined.html')
}
