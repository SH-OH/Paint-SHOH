//
//  PKCanvasControlable.swift
//  Paint-SHOH
//
//  Created by Oh Sangho on 2021/04/19.
//

import Foundation
import UIKit
import PencilKit
import Then

protocol PKCanvasControlable: class {
    var backgroundView: UIImageView { get }
    var canvasView: PKCanvasView { get }
}

extension PKCanvasControlable {
    static func initBackgroundView() -> UIImageView {
        return UIImageView().then {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
        }
    }
    
    static func initCanvas() -> PKCanvasView {
        return PKCanvasView().then {
            $0.tool = PKInkingTool(.pen, color: .black, width: 10)
            $0.allowsFingerDrawing = true
            $0.backgroundColor = .clear
            $0.isOpaque = false
        }
    }
    
    func save() {
        print(#function)
    }
    
    func load() {
        print(#function)
    }
    
    func add(_ presentViewController: BaseViewController) {
        self._add(presentViewController) { [weak backgroundView] (image) in
            backgroundView?.image = image
        }
    }
    
    func undo() {
        canvasView.undoManager?.undo()
        print(#function)
    }
    
    func redo() {
        canvasView.undoManager?.redo()
        print(#function)
    }
    
    func pen() {
        canvasView.tool = _pan
        print(#function)
    }
    
    func erase() {
        canvasView.tool = _eraser
        print(#function)
    }
}

// MARK: - Private

extension PKCanvasControlable {
    private var _pan: PKInkingTool {
        return PKInkingTool(
            .pen,
            color: .black,
            width: 10
        )
    }
    private var _eraser: PKEraserTool {
        return PKEraserTool(.bitmap)
    }
    
    private func _add(
        _ presentViewController: BaseViewController,
        completion: @escaping ImagePicker.ImagePickerCompletion
    ) {
        ImagePicker().present(
            to: presentViewController,
            completion: completion
        )
    }
}
