//
//  BaseView.swift
//  Paint-SHOH
//
//  Created by Oh Sangho on 2021/04/19.
//

import UIKit.UIView
import RxSwift

class BaseView: UIView {
    
    var disposeBag: DisposeBag = .init()
    
    deinit {
        print("[👋 deinit]\(String(describing: self))")
    }
    
}

extension BaseView {
    
    private static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    static func loadFromNib() -> Self {
        let name = Self.reuseIdentifier
        let bundle = Bundle(for: Self.self)
        guard let view = bundle.loadNibNamed(
            name,
            owner: self,
            options: nil
        )?.first as? Self else {
            preconditionFailure("Nib : '\(name)' load 실패")
        }
        return view
    }
}
