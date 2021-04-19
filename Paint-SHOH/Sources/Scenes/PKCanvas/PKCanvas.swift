//
//  PKCanvas.swift
//  Paint-SHOH
//
//  Created by Oh Sangho on 2021/04/19.
//

import PencilKit

final class PKCanvas: UIView, PKCanvasControlable {
    let backgroundView = PKCanvas.initBackgroundView()
    let canvasView = PKCanvas.initCanvas()
    var cacheDrawing: PKDrawing?
    var presentViewController: BaseViewController?
    let isStub: Bool = false
    
    func setup(_ presentViewController: BaseViewController) {
        self.presentViewController = presentViewController
        
        setupView()
        setupLayout()
    }
    
    private func setupView() {
        self.addSubview(backgroundView)
        self.addSubview(canvasView)
    }
    
    private func setupLayout() {
        backgroundView.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
        canvasView.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
    }
}
