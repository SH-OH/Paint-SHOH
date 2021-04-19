//
//  MainViewController.swift
//  Paint-SHOH
//
//  Created by Oh Sangho on 2021/04/19.
//

import UIKit
import SnapKit

final class MainViewController: BaseViewController {
    
    private let controlHeaderView = ControlHeaderView.loadFromNib()
    private let canvasView = CanvasView.loadFromNib()
    
    override func setupView() {
        view.backgroundColor = .systemGray3
        
        view.addSubview(controlHeaderView)
        view.addSubview(canvasView)
    }
    
    override func setupLayout() {
        controlHeaderView.snp.makeConstraints { (m) in
            m.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            m.leading.trailing.equalToSuperview()
            m.height.equalTo(60)
            
        }
        canvasView.snp.makeConstraints { (m) in
            m.top.equalTo(controlHeaderView.snp.bottom).offset(5)
            m.leading.trailing.equalToSuperview().inset(5)
            m.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(5)
        }
    }
}

