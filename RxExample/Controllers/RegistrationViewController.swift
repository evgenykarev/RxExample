//
//  RegistrationViewController.swift
//  RxExample
//
//  Created by Evgeny Karev on 12/06/2019.
//  Copyright © 2019 EKarev. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class RegistrationViewController: UIViewController {
    
    var viewModel: RegistrationViewModel!
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    
    @IBOutlet weak var loginValidationLabel: ValidationLabel!
    @IBOutlet weak var loginCheckActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passwordValidationLabel: ValidationLabel!
    @IBOutlet weak var passwordConfirmValidationLabel: ValidationLabel!
    
    @IBOutlet weak var confirmationView: UIView!
    
    @IBOutlet weak var registerButton: UIButton!
    
    private var activeButtonColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activeButtonColor = registerButton.backgroundColor
        
        configureObservation()
    }
    
    func configureObservation() {
        (loginTextField.rx.text <-> viewModel.login).disposed(by: disposeBag)
        (passwordTextField.rx.text <-> viewModel.password).disposed(by: disposeBag)
        (passwordConfirmTextField.rx.text <-> viewModel.passwordConfirm).disposed(by: disposeBag)
        
        viewModel.isloginValidationLoading.asObservable()
            .bind(to: loginValidationLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.isloginValidationLoading.asObservable()
            .bind(to: loginCheckActivityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.isloginValidationLoading.asObservable()
            .map({ !$0 })
            .bind(to: loginCheckActivityIndicator.rx.isHidden)
            .disposed(by: disposeBag)

        // Аналогичная логика
//        viewModel.isloginValidationLoading.asObservable()
//            .subscribe(onNext: { [weak self] (isloginValidationLoading) in
//                self?.loginValidationLabel.isHidden = isloginValidationLoading
//                self?.loginCheckActivityIndicator.isHidden = !isloginValidationLoading
//                if isloginValidationLoading {
//                    self?.loginCheckActivityIndicator.startAnimating()
//                } else {
//                    self?.loginCheckActivityIndicator.stopAnimating()
//                }
//            })
//            .disposed(by: disposeBag)
        
        viewModel.loginValidationResult.asObservable()
            .bind(to: loginValidationLabel.rx.validationResult)
            .disposed(by: disposeBag)
        
        viewModel.passwordValidationResult.asObservable()
            .bind(to: passwordValidationLabel.rx.validationResult)
            .disposed(by: disposeBag)
        
        viewModel.passwordValidationResult.asObservable()
            .bind(to: passwordConfirmValidationLabel.rx.validationResult)
            .disposed(by: disposeBag)
        
        let unwrappedValidationResult = viewModel.validationResult.asObservable()
            .map({ (validationResult: Bool?) -> Bool in
                return validationResult ?? false
            })
            
        unwrappedValidationResult
            .bind(to: registerButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        let activeButtonColor = self.activeButtonColor
        unwrappedValidationResult
            .map({ $0 ? activeButtonColor : UIColor.lightGray })
            .bind(to: registerButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        viewModel.validationResult.asObservable()
            .map({ (validationResult: Bool?) -> Bool in
                return validationResult ?? false
            })
            .bind(to: registerButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.confirmationIsHidden
            .bind(to: confirmationView.rx.isHidden)
            .disposed(by: disposeBag)
    
    }
    
}

extension RegistrationViewController: StoryboardInstantiatableWithViewModel {
    
    typealias ViewModel = RegistrationViewModel
    
}
