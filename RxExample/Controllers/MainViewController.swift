//
//  MainViewController.swift
//  RxExample
//
//  Created by Evgeny Karev on 09/06/2019.
//  Copyright © 2019 EKarev. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let navigationController = self.navigationController else { return }
        
        switch indexPath.row {
        case 0:
            let viewModel = RegistrationViewModel()
            let controller = RegistrationViewController.instantiateFromStoryboard(with: viewModel)
            navigationController.pushViewController(controller, animated: true)
        case 1:
            let viewModel = SimpleTableViewViewModel()
            let controller = SimpleTableViewController.instantiateFromStoryboard(with: viewModel)
            navigationController.pushViewController(controller, animated: true)
        case 2:
            let viewModel = SimpleFormViewModel()
            let controller = SimpleFormViewController.instantiateFromStoryboard(with: viewModel)
            navigationController.pushViewController(controller, animated: true)
        default:
            break
        }
    }

}

