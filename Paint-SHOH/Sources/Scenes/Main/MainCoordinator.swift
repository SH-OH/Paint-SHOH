//
//  MainCoordinator.swift
//  Paint-SHOH
//
//  Created by Oh Sangho on 2021/04/19.
//

import UIKit

final class MainCoordinator: Coordinator {
    
    private unowned var navigationController: BaseNavigationController
    
    init(_ navigationController: BaseNavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let mainVC = MainViewController()
        navigationController.setViewControllers(
            [mainVC],
            animated: false
        )
    }
}
