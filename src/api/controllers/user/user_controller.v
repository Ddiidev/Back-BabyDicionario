module user

import domain.user.interfaces
import api.ws_context
import veb

@[noinit]
pub struct WsUser {
	veb.Middleware[ws_context.Context]
	huser_service              interfaces.IUserService
	huser_confirmation_service interfaces.IUserConfirmationService
	huser_recovery_service     interfaces.IUserRecoveryService
}

@[params]
pub struct WsUserParam {
pub:
	huser_service              interfaces.IUserService
	huser_confirmation_service interfaces.IUserConfirmationService
	huser_recovery_service     interfaces.IUserRecoveryService
}

pub fn WsUser.new(param WsUserParam) &WsUser {
	return &WsUser{
		huser_service:              param.huser_service
		huser_confirmation_service: param.huser_confirmation_service
		huser_recovery_service:     param.huser_recovery_service
	}
}
