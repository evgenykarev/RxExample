//
//  RxTableViewCell.swift
//  RxExample
//
//  Created by Evgeny Karev on 11/06/2019.
//  Copyright © 2019 EKarev. All rights reserved.
//

import UIKit
import RxSwift

class RxTableViewCell: UITableViewCell {
    
    private (set) var disposeBag = DisposeBag()
    
    func resetDisposeBag() {
        self.disposeBag = DisposeBag()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetDisposeBag()
    }
    
}
