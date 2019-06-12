//
//  SimpleFormViewController.swift
//  RxExample
//
//  Created by Evgeny Karev on 11/06/2019.
//  Copyright © 2019 EKarev. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import RxCocoa

class SimpleFormViewController: UIViewController {
    
    var viewModel: SimpleFormViewModel!
    
    let disposeBag = DisposeBag()
    
    var dataSource: RxTableViewSectionedAnimatedDataSource<ViewModel.Section>!
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.register(UINib(nibName: "InputCell", bundle: .main), forCellReuseIdentifier: "InputCell")
        tableView.register(UINib(nibName: "ValidationResultCell", bundle: .main), forCellReuseIdentifier: "ValidationResultCell")
        tableView.register(UINib(nibName: "ButtonCell", bundle: .main), forCellReuseIdentifier: "ButtonCell")
        
        configureDataSource()
    }
    
}

extension SimpleFormViewController {
    
    func configureDataSource() {
        self.dataSource = RxTableViewSectionedAnimatedDataSource<ViewModel.Section>(
            configureCell: {  [weak viewModel] dataSource, tableView, indexPath, item in
                guard let viewModel = viewModel else { return UITableViewCell() }
                
                switch item {
                case .header:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") ?? UITableViewCell()
                    cell.textLabel?.text = "Form example"
                    return cell
                case .input:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "InputCell") as! InputCell
                    (cell.textField.rx.text <-> viewModel.value).disposed(by: cell.disposeBag)
                    return cell
                case .validation:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ValidationResultCell") as! ValidationResultCell
                    viewModel.validationResult.asObservable()
                        .bind(to: cell.rx.validationResult)
                        .disposed(by: cell.disposeBag)
                    // or
                    // cell.configureObservation(validationResult: viewModel.validationResult.asObservable())
                    return cell
                case .footer:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell") as! ButtonCell
                    cell.button.rx.tap
                        .subscribe(onNext: { [weak viewModel] _ in
                            viewModel?.startValidate()
                        })
                        .disposed(by: cell.disposeBag)
                    return cell
                }
        })
        
        viewModel.section.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
}

extension SimpleFormViewController: StoryboardInstantiatableWithViewModel {
    
    typealias ViewModel = SimpleFormViewModel
    
}

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
