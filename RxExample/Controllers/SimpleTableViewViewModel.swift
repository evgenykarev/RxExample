//
//  SimpleTableViewViewModel.swift
//  RxExample
//
//  Created by Evgeny Karev on 09/06/2019.
//  Copyright © 2019 EKarev. All rights reserved.
//

import Foundation
import Differentiator
import RxCocoa

class SimpleTableViewViewModel {
    
    let sections: BehaviorRelay<[Section]>
    
    private var id: Int = 0
    private func nextId() -> Int {
        defer { id += 1 }
        return id
    }
    
    init() {
        self.sections = BehaviorRelay(value: [])
    }
    
    func appendSection() {
        var sections = self.sections.value
        
        let section = Section(header: "New \(sections.count)", items: [
            Model(id: nextId(), title: "Model 0"),
            Model(id: nextId(), title: "Model 1"),
            ])
        
        sections.append(section)
        
        self.sections.accept(sections)
    }
    
    func updateFirstSection() {
        var sections = self.sections.value
        for i in 0..<sections[0].items.count {
            sections[0].items[i].title = "updated"
        }
        self.sections.accept(sections)
    }
    
}

extension SimpleTableViewViewModel {
    
    struct Model: IdentifiableType, Equatable {
        
        typealias Identity = Int
        
        let id: Int
        var title: String
        
        var identity: Int {
            return id
        }
        
    }
    
    struct Section: AnimatableSectionModelType {
        
        typealias Identity = String
        
        var header: String
        var items: [Model]
        
        var identity: String {
            return header
        }
        
        init(header: String, items: [Model]) {
            self.header = header
            self.items = items
        }
        
        init(original: Section, items: [Model]) {
            self = original
            self.items = items
        }
        
    }
    
}
