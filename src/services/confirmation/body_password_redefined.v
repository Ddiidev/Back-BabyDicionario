module confirmation

import contracts.contract_shared

// body_password_redefined
// ip	-	IP da página solicitante
// date	-	Data da solicitação
fn body_password_redefined(ip string, date contract_shared.JsTime) string {

	email_dicionario_baby := $env('BABYDI_SMTP_EMAIL_FROM')

	return $tmpl('msg_password_redefined.html')
}