//
//  PhoneNumberViewModel.swift
//  Bold
//
//  Created by Нуржан Орманали on 24.03.2021.
//

import Foundation

protocol PhoneNumberViewModelInterface {
    var worker: AutharizationWorkerInterface { get }
    var presenter: PhoneNumberViewUIInterface? { get set }
    var controllerPresenter: PhoneNumberViewControllerInterface? { get set }
    func checkOrRegistrateNumber(with phoneNumber: String)
}

class RegistratePhoneNumberViewModel: PhoneNumberViewModelInterface {
    
    var worker: AutharizationWorkerInterface = AutharizationWorker()
    
    var presenter: PhoneNumberViewUIInterface?
    weak var controllerPresenter: PhoneNumberViewControllerInterface?
    
    func checkOrRegistrateNumber(with phoneNumber: String) {
        DispatchQueue.global().async {
            let response = self.worker.registratePhoneNumber(from: AutharizationEndpoint.registratePhoneNumberAndSendVerificationCode(phoneNumber: phoneNumber))
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
