//
//  ObservableType+Extensions.swift
//  Paint-SHOH
//
//  Created by Oh Sangho on 2021/04/19.
//

import RxSwift
import RxCocoa

extension ObservableType {
    func asDriverOnEmpty() -> Driver<Element> {
        return asDriver(onErrorDriveWith: .empty())
    }
}
