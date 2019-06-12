//
//  SimpleFormViewModel.swift
//  RxExample
//
//  Created by Evgeny Karev on 11/06/2019.
//  Copyright © 2019 EKarev. All rights reserved.
//

import Foundation
import Differentiator
import RxSwift
import RxCocoa

class SimpleFormViewModel {
    
    typealias Section = AnimatableSection<Item>
    
    let disposeBag = DisposeBag()
    let section: Section
    let value: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    let validationResult: BehaviorRelay<Bool?> = BehaviorRelay(value: nil)
    
    private var isValidationStarted = false
    
    init() {
        self.section = AnimatableSection(items: [.header, .input, .footer])
    }
    
    private func validate(value: String) -> Bool {
        return value.lowercased() == "rx"
    }
    
    func startValidate() {
        guard !isValidationStarted else { return }
        isValidationStarted = true
        
        section.items[2] = .validation
        
        /// Отслеживание изменения значения
        value.asObservable()
            .flatMap({ Observable.from(optional: $0) })
            .map({ [weak self] (value: String) -> Bool in
                return self?.validate(value: value) ?? false
            })
            .distinctUntilChanged()
            .bind(to: validationResult)
            .disposed(by: disposeBag)
    }
    
}

extension SimpleFormViewModel {
    
    enum Item: String, IdentifiableType {
        case header, input, validation, footer
    }
    
}

// Применение RawRepresentable в качестве IdentifiableType
extension RawRepresentable where RawValue: Equatable {
    
    typealias Identity = RawValue
    
    var identity: Identity {
        return self.rawValue
    }
    
}

/// Обертка над AnimatableSectionModelType
class AnimatableSection<T: IdentifiableType & Equatable>: AnimatableSectionModelType {
    
    typealias Item = T
    typealias Identity = String
    
    let identity: String
    
    var items: [Item] {
        didSet {
            observableSection.onNext([self])
        }
    }
    
    private let observableSection: PublishSubject<[AnimatableSection<T>]> = PublishSubject()
    
    func asObservable() -> Observable<[AnimatableSection<T>]> {
        return observableSection.asObservable().startWith([self])
    }
    
    required init(original: AnimatableSection<T>, items: [T]) {
        self.identity = original.identity
        self.items = items
    }
    
    init(identity: String? = nil, items: [T] = []) {
        self.identity = identity ?? UUID().uuidString
        self.items = items
    }

}
