//
//  ValidationResultCell.swift
//  RxExample
//
//  Created by Evgeny Karev on 11/06/2019.
//  Copyright © 2019 EKarev. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa

class ValidationResultCell: RxTableViewCell {
    
    @IBOutlet weak var label: ValidationLabel!
    
    var validationResult: Bool? {
        get {
            return label.validationResult
        }
        set {
            label.validationResult = newValue
        }
    }
    
    func configureObservation(validationResult: Observable<Bool?>) {
        validationResult
            .subscribe(onNext: { [weak self] (validationResult: Bool?) in
                self?.validationResult = validationResult
            })
            .disposed(by: disposeBag)
    }
    
}

extension Reactive where Base: ValidationResultCell {
    
    var validationResult: Binder<Bool?> {
        return Binder(self.base) { cell, validationResult in
            cell.validationResult = validationResult
        }
    }
    
}
