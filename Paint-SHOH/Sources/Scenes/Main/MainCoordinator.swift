//
//  MainCoordinator.swift
//  Paint-SHOH
//
//  Created by Oh Sangho on 2021/04/19.
//

import UIKit

protocol MainFlow: class {
    func coordinateToNextAny()
}

final class MainCoordinator: Coordinator, MainFlow {
    
    private unowned var navigationController: BaseNavigationController
    
    init(_ navigationController: BaseNavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let reactor = MainViewReactor()
        let mainVC = MainViewController.storyboard()
        mainVC.reactor = reactor
        mainVC.coordinator = self
        navigationController.setViewControllers(
            [mainVC],
            animated: false
        )
    }
    
    func coordinateToNextAny() {
        print(#function)
    }
}
