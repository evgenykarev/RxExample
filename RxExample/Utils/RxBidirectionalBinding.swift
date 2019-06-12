//
//  RxBidirectionalBinding.swift
//  RxExample
//
//  Created by Evgeny Karev on 12/06/2019.
//  Copyright © 2019 EKarev. All rights reserved.
//

import RxSwift
import RxCocoa

// From official example https://github.com/ReactiveX/RxSwift/blob/master/RxExample/RxExample/Operators.swift#L17
infix operator <-> : DefaultPrecedence

func <-> <T>(property: ControlProperty<T>, relay: BehaviorRelay<T>) -> Disposable {
    let bindToUIDisposable = relay.bind(to: property)
    let bindToRelay = property
        .subscribe(onNext: { n in
            relay.accept(n)
        }, onCompleted:  {
            bindToUIDisposable.dispose()
        })
    
    return Disposables.create(bindToUIDisposable, bindToRelay)
}
