//
//  AppCoordinator.swift
//  Paint-SHOH
//
//  Created by Oh Sangho on 2021/04/19.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let navigationController = BaseNavigationController()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        let main = MainCoordinator(navigationController)
        coordinate(to: main)
    }
}
