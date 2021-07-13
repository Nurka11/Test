//
//  PhoneNumberRegistrationView.swift
//  Bold
//
//  Created by Нуржан Орманали on 06.03.2021.
//

import UIKit
import SnapKit

protocol PhoneNumberRegistrationViewInterface: KeyboardAppearingDelegate, PhoneNumberViewUIInterface {
    var phoneNumberRegistrationViewDelegate: PhoneNumberRegistrationViewDelegate? { get set }
    func getEnteredPhoneNumber() -> String?
}

protocol PhoneNumberRegistrationViewDelegate: class {
    func nextButtonDidPressed()
}

protocol PhoneNumberViewUIInterface {
    func showFillingError(with errorMessage: String?)
}

class PhoneNumberRegistrationView: UIView {
    
    weak var phoneNumberRegistrationViewDelegate: PhoneNumberRegistrationViewDelegate?
    
    // MARK: Properties
    private(set) var titleTopBarView: TitleTopBarView = {
        let view = TitleTopBarView()
        view.primaryTitleText = "sign up"
        view.secondaryTitleText = "Enter your phone number for registration\nto game"
        
        return view
    }()
    
    lazy private var phoneNumberTextField: InputTextField = {
        let textField = InputTextField()
        textField.placeholderText = "phone number"
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.delegate = self
        textField.keyboardType = .asciiCapable
        textField.maskString = "+7 ([000]) [000] [00] [00]"
        
        return textField
    }()
    
    private var nextButtonBottomConstraint: Constraint!
    
    lazy private var registrateButton: PrimaryButton = {
        let button = PrimaryButton()
        button.setTitle("Next", for: .normal)
        button.addTarget(self, action: #selector(checkPhoneNumberAction), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSuperViewAppearances()
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSuperViewAppearances() {
        backgroundColor = .background
    }
    
    private func setupViews() {
        addSubview(titleTopBarView)
        addSubview(phoneNumberTextField)
        addSubview(registrateButton)
    }
    
    private func setupConstraints() {
        /// Superview margin
        layoutMargins = UIEdgeInsets(top: 15.byPercentage, left: 25.byPercentage, bottom: 40.byPercentage, right: 25.byPercentage)
        
        titleTopBarView.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview().inset(layoutMargins)
        }
        
        phoneNumberTextField.snp.makeConstraints { (make) in
            make.top.equalTo(titleTopBarView.snp.bottom).offset(40.byPercentage)
            make.leading.trailing.equalToSuperview().inset(layoutMargins)
            make.height.equalTo(inputTextFieldHeight)
        }
        
        registrateButton.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(primaryButtonHeight)
            if #available(iOS 11.0, *) {
                nextButtonBottomConstraint = make.bottom.equalTo(safeAreaLayoutGuide).inset(layoutMargins).constraint
            } else {
                nextButtonBottomConstraint = make.bottom.equalToSuperview().inset(layoutMargins).constraint
            }
        }
        
    }
    
}

extension PhoneNumberRegistrationView {
    
    @objc private func checkPhoneNumberAction() {
        phoneNumberRegistrationViewDelegate?.nextButtonDidPressed()
    }
    
}

extension PhoneNumberRegistrationView: PhoneNumberViewUIInterface {
    
    func showFillingError(with errorMessage: String?) {
        phoneNumberTextField.animate(with: .error, animated: true)
        phoneNumberTextField.showErrorMessage(with: errorMessage ?? "")
    }

}

extension PhoneNumberRegistrationView: PhoneNumberRegistrationViewInterface {
    
    func getEnteredPhoneNumber() -> String? {
        return phoneNumberTextField.unmaskedText
    }
    
    func updateConstraintsByKeyboard(with height: CGFloat) {
        registrateButton.setToKeyboard(with: nextButtonBottomConstraint, and: height)
    }
    
}

extension PhoneNumberRegistrationView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
