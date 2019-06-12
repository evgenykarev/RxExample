//
//  RegistrationViewModel.swift
//  RxExample
//
//  Created by Evgeny Karev on 12/06/2019.
//  Copyright © 2019 EKarev. All rights reserved.
//

import RxSwift
import RxCocoa

class RegistrationViewModel {
    
    let disposeBag = DisposeBag()
    
    let login: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    let password: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    let passwordConfirm: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    
    let isloginValidationLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let loginValidationResult: BehaviorRelay<Bool?> = BehaviorRelay(value: nil)
    let passwordValidationResult: BehaviorRelay<Bool?> = BehaviorRelay(value: nil)
    
    let validationResult: BehaviorRelay<Bool?> = BehaviorRelay(value: nil)
    
    /// Hiding confirmation
    var confirmationIsHidden: Observable<Bool> {
        let observable = password.asObservable()
            .map({ $0?.isEmpty ?? true })
        return observable
    }
    
    init() {
        configureObservation()
    }
    
    private func validateLogin(login: String) {
        loginValidationResult.accept(false)
        isloginValidationLoading.accept(true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak loginValidationResult, weak isloginValidationLoading] in
            let validationResult = login.count > 2
            isloginValidationLoading?.accept(false)
            loginValidationResult?.accept(validationResult)
        }
    }
    
    func configureObservation() {
        
        login.asObservable()
            .map({ $0 ?? "" })
            .distinctUntilChanged()
            .skip(1)
            .debounce(.seconds(2), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (login: String) in
                self?.validateLogin(login: login)
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(password.asObservable(), passwordConfirm.asObservable())
            .subscribe(onNext: { [weak passwordValidationResult] (password: String?, passwordConfirm: String?) in
                guard let password = password, !password.isEmpty else {
                    passwordValidationResult?.accept(nil)
                    return
                }
                passwordValidationResult?.accept(password == passwordConfirm)
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(loginValidationResult.asObservable(), passwordValidationResult.asObservable())
            .map({ ($0 ?? false) && ($1 ?? false) })
            .bind(to: validationResult)
            .disposed(by: disposeBag)
        
        // when password become empty confirm set nil
        password.asObservable()
            .filter({ $0?.isEmpty ?? true })
            .subscribe(onNext: { [weak passwordConfirm] _ in
                passwordConfirm?.accept(nil)
            })
            .disposed(by: disposeBag)
        
    }
    
}
