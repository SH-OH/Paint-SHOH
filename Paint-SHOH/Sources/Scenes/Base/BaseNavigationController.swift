//
//  BaseNavigationController.swift
//  Paint-SHOH
//
//  Created by Oh Sangho on 2021/04/19.
//

import UIKit.UINavigationController

final class BaseNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarHidden(true, animated: false)
    }
    
}
