//
//  SimpleTableViewController.swift
//  RxExample
//
//  Created by Evgeny Karev on 09/06/2019.
//  Copyright © 2019 EKarev. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class SimpleTableViewController: UIViewController {
    
    var viewModel: SimpleTableViewViewModel!
    
    let disposeBag = DisposeBag()
    
    var dataSource: RxTableViewSectionedAnimatedDataSource<ViewModel.Section>!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.viewModel.appendSection()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.viewModel.appendSection()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.viewModel.updateFirstSection()
        }
        
    }
    
}

extension SimpleTableViewController {
    
    func configureDataSource() {
        self.dataSource = RxTableViewSectionedAnimatedDataSource<ViewModel.Section>(
            configureCell: { dataSource, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
                cell.textLabel?.text = "Item \(item.title)"
                
                return cell
        },
            titleForHeaderInSection: { dataSource, index in
                return "Section \(dataSource.sectionModels[index].header)"
        }
        )
        
        viewModel.sections.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

}

extension SimpleTableViewController: StoryboardInstantiatableWithViewModel {
    
    typealias ViewModel = SimpleTableViewViewModel
    
}
