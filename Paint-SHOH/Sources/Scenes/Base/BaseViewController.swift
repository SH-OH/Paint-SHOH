//
//  BaseViewController.swift
//  Paint-SHOH
//
//  Created by Oh Sangho on 2021/04/19.
//

import Foundation
import UIKit.UIViewController
import RxSwift

class BaseViewController: UIViewController {
    
    var disposeBag: DisposeBag = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
    }
    
    deinit {
        print("[👋 deinit]\(String(describing: self))")
    }
    
    
    func setupView() {}
    func setupLayout() {}
}

extension BaseViewController {
    
    private static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    static func storyboard() -> Self {
        let name = self.reuseIdentifier
        let storyboard = UIStoryboard(name: name, bundle: nil)
        guard let vc = storyboard.instantiateViewController(
            withIdentifier: name
        ) as? Self else {
            preconditionFailure("Storyboard : '\(name)' load 실패")
        }
        return vc
    }
}
