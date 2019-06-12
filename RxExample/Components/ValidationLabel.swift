//
//  ValidationLabel.swift
//  RxExample
//
//  Created by Evgeny Karev on 12/06/2019.
//  Copyright © 2019 EKarev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ValidationLabel: UILabel {
    
    var validationResult: Bool? = nil {
        didSet {
            if let result = validationResult {
                self.text = result ? "👍" : "👎"
            } else {
                self.text = nil
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        validationResult = nil
    }
    
}

extension Reactive where Base: ValidationLabel {
    
    var validationResult: Binder<Bool?> {
        return Binder(self.base) { label, validationResult in
            label.validationResult = validationResult
        }
    }
    
}
