//
//  ResetPasswordPhoneViewModel.swift
//  Bold
//
//  Created by Нуржан Орманали on 24.03.2021.
//

import Foundation

class ResetPasswordPhoneViewModel: RegistratePhoneNumberViewModel {
    
    override func checkOrRegistrateNumber(with phoneNumber: String) {
        DispatchQueue.global().async {
            let response = self.worker.registratePhoneNumber(from: AutharizationEndpoint.resetPasswordPhoneNumberCheckAndSendVerificationCode(phoneNumber: phoneNumber))
            switch response {
            case .failure(let error):
                debugPrint(error)
                DispatchQueue.main.async {
                    self.presenter?.showFillingError(with: error.errorModel.message)
                }
            case .success:
                DispatchQueue.main.async {
                    self.controllerPresenter?.phoneNumberCheckSuccess(of: phoneNumber)
                }
            }
        }
    }
    
}
