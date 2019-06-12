//
//  StoryboardInstantiatable.swift
//  RxExample
//
//  Created by Evgeny Karev on 09/06/2019.
//  Copyright © 2019 EKarev. All rights reserved.
//

import UIKit

protocol StoryboardInstantiatable: class {
    
}

extension StoryboardInstantiatable where Self: UIViewController {
    
    static func instantiateFromStoryboard() -> Self {
        let controller: Self = UIStoryboard(name: String(describing: self), bundle: Bundle.main).instantiateInitialViewController() as! Self
        return controller
    }
    
}

protocol StoryboardInstantiatableWithViewModel: StoryboardInstantiatable {
    
    associatedtype ViewModel
    
    var viewModel: ViewModel! { get set }
    
}

extension StoryboardInstantiatableWithViewModel where Self: UIViewController {
    
    static func instantiateFromStoryboard(with viewModel: ViewModel) -> Self {
        let controller = Self.instantiateFromStoryboard()
        controller.viewModel = viewModel
        return controller
    }
    
}
