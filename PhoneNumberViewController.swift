//
//  PhoneNumberRegistrationViewController.swift
//  Bold
//
//  Created by Нуржан Орманали on 06.03.2021.
//

import UIKit

protocol PhoneNumberViewCoordinatorDelegate {
    func openCodeVerificationController(with phoneNumber: String)
}

protocol PhoneNumberViewControllerInterface: class {
    func phoneNumberCheckSuccess(of phoneNumber: String)
}

class PhoneNumberViewController: UIViewController {
    
    // MARK: Properties
    private var superView: PhoneNumberRegistrationViewInterface!
    private var viewModel: PhoneNumberViewModelInterface!
    
    public var coordinatorDelegate: PhoneNumberViewCoordinatorDelegate?
    
    lazy private var pageControlImage: UIBarButtonItem = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "page_control_2"))
        
        return UIBarButtonItem(customView: imageView)
    }()
    
    // MARK: Life cycle
    init(with viewModel: PhoneNumberViewModelInterface, and superview: PhoneNumberRegistrationViewInterface) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.superView = superview
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegating()
        setupNavigationItem()
    }
    
    override func loadView() {
        edgesForExtendedLayout = []
        view = superView as? UIView
        addTapGestureToDismissKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterKeyboardNotifications()
    }
    
    deinit {
        (superView as? UIView)?.removeFromSuperview()
        print("Registration view controller deinited")
    }
    
    private func delegating() {
        superView.phoneNumberRegistrationViewDelegate = self
        
        viewModel.presenter = superView
        viewModel.controllerPresenter = self
    }
    
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = pageControlImage
    }
    
    private func registerKeyboardNotifications() {
        registerKeyboardNotifications { (payload) in
            self.superView.updateConstraintsByKeyboard(with: payload.endFrame.height)
        } onHide: { (_) in
            self.superView.updateConstraintsByKeyboard(with: 0)
        }

    }
    
}

extension PhoneNumberViewController: PhoneNumberViewControllerInterface {
    
    func phoneNumberCheckSuccess(of phoneNumber: String) {
        coordinatorDelegate?.openCodeVerificationController(with: phoneNumber)
    }
    
}

extension PhoneNumberViewController: PhoneNumberRegistrationViewDelegate {
    
    func nextButtonDidPressed() {
        guard let phoneNumber = superView.getEnteredPhoneNumber(), !phoneNumber.isEmpty else {
            superView.showFillingError(with: nil)
            return
        }
        viewModel.checkOrRegistrateNumber(with: phoneNumber)
    }
    
}
