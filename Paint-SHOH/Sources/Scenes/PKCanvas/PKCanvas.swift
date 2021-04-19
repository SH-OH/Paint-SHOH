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
    
    func setup() {
        canvasView.delegate = self
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

// MARK: - PKCanvasViewDelegate

extension PKCanvas: PKCanvasViewDelegate {
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        print(#function)
    }
    func canvasViewDidFinishRendering(_ canvasView: PKCanvasView) {
        print(#function)
    }
    func canvasViewDidEndUsingTool(_ canvasView: PKCanvasView) {
        print(#function)
    }
    func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
        print(#function)
    }
}
