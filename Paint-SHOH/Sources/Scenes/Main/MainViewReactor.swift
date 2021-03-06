//
//  MainViewReactor.swift
//  Paint-SHOH
//
//  Created by Oh Sangho on 2021/04/19.
//

import ReactorKit

final class MainViewReactor: Reactor {
    typealias Action = NoAction
    
    struct State {}
    
    let initialState: State
    
    init() {
        self.initialState = .init()
    }
    
}
