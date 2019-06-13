//
//  RxSubjectViewController.swift
//  RxExample
//
//  Created by Evgeny Karev on 13/06/2019.
//  Copyright © 2019 EKarev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxSubjectViewController: UIViewController, StoryboardInstantiatable {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var sequence1TextField: UITextField!
    @IBOutlet weak var sequence2TextField: UITextField!
    
    @IBOutlet weak var logLabel: UILabel!
    
    let logSubject: PublishSubject<Int> = PublishSubject()
    
    let publishSubject1: PublishSubject<Int> = PublishSubject()
    let publishSubject2: PublishSubject<Int> = PublishSubject()
    
    let behaviorSubject1: BehaviorSubject<Int> = BehaviorSubject(value: 0)
    let behaviorSubject2: BehaviorSubject<Int> = BehaviorSubject(value: 0)
    
    let variable1: Variable<Int> = Variable(0)
    let variable2: Variable<Int> = Variable(0)
    
    let behaviorRelay1: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    let behaviorRelay2: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    
    @IBAction func sequence1ButtonTapped(_ sender: Any) {
        guard let text = sequence1TextField.text, let value = Int(text) else { return }
        sequence1TextField.text = String(value + 1)
        
        publishSubject1.onNext(value)
        behaviorSubject1.onNext(value)
        variable1.value = value
        behaviorRelay1.accept(value)
        logSubject.onNext(value)
    }
    
    @IBAction func sequence2ButtonTapped(_ sender: Any) {
        guard let text = sequence2TextField.text, let value = Int(text) else { return }
        sequence2TextField.text = String(value + 1)
        
        publishSubject2.onNext(value)
        behaviorSubject2.onNext(value)
        variable2.value = value
        behaviorRelay2.accept(value)
        logSubject.onNext(value)
    }
    
    func helloWorld() {
        let characters = "Hello world!".map({ $0 })
        let helloSequence = Observable.from(characters)
        let subscription = helloSequence.subscribe { event in
            switch event {
            case .next(let value):
                print(value)
            case .error(let error):
                print(error)
            case .completed:
                print("completed")
            }
        }
        subscription.dispose()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sequence1TextField.text = "0"
        sequence2TextField.text = "0"
        logLabel.text = nil
        
        let disposable = logSubject.asObservable()
            .subscribe(onNext: { [weak logLabel] (value) in
                guard let logLabel = logLabel else { return }
                if let text = logLabel.text, !text.isEmpty {
                    logLabel.text = text + "\n" + String(value)
                } else {
                    logLabel.text = String(value)
                }
            }, onDisposed: {
                print("log disoposed")
            })
        disposable.disposed(by: disposeBag)
    }
    
}
