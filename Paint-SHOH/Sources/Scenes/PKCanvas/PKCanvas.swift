//
//  PKCanvas.swift
//  Paint-SHOH
//
//  Created by Oh Sangho on 2021/04/19.
//

import PencilKit

final class PKCanvas: UIImageView, PKCanvasControlable {
    let canvasView = PKCanvas.initCanvas()
    
    func setup() {
        contentMode = .scaleAspectFill
        backgroundColor = .blue
        clipsToBounds = true
        canvasView.delegate = self
        setupCanvasView()
    }
    
    private func setupCanvasView() {
        self.addSubview(canvasView)
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
