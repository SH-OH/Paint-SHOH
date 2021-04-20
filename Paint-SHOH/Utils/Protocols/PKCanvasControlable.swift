//
//  PKCanvasControlable.swift
//  Paint-SHOH
//
//  Created by Oh Sangho on 2021/04/19.
//

import UIKit
import PencilKit
import Then
import SPMSHOHProxy

protocol PKCanvasControlable: UIView {
    var presentViewController: BaseViewController? { get }
    var backgroundView: UIImageView { get }
    var canvasView: PKCanvasView { get }
    var isStub: Bool { get }
}

extension PKCanvasControlable {
    
    // MARK: - Init Method
    
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
    
    // MARK: - Control Method
    
    func save() {
        let drawing = canvasView.drawing
        guard !drawing.bounds.isEmpty else {
            return
        }
        
        guard let url = directoryUrl else { return }
        let imageData = self.backgroundView.image?.jpegData(compressionQuality: 1.0)
        queue.async {
            let imageEncodedString = imageData?.base64EncodedString()
            
            let model = CanvasModel(
                backgroundImageEncodedString: imageEncodedString,
                drawing: drawing
            )
            
            do {
                let data = try model.encode()
                try data.write(to: url)
                self.toastMessage()
            } catch {
                print("CanvasModel Save 실패 : \(error)")
            }
        }
    }
    
    func load() {
        guard let url = directoryUrl else { return }
        
        queue.async {
            if FileManager.default.fileExists(atPath: url.path) {
                do {
                    let data = try Data(contentsOf: url)
                    let model = try CanvasModel.decode(data: data)
                    let imageData = Data(base64Encoded: model.backgroundImageEncodedString ?? "")
                    
                    DispatchQueue.main.async {
                        if let imageData = imageData, !imageData.isEmpty {
                            self.backgroundView.image = UIImage(data: imageData)
                        }
                        self.setUndoCanvas(model.drawing)
                        self.canvasView.drawing = model.drawing
                    }
                } catch {
                    print("CanvasModel Load 실패 : \(error)")
                }
            } else {
                self.alertMessage()
            }
        }
    }
    
    func add() {
        self._add() { [weak self] (image) in
            self?.setUndoBackgroundImage(image)
            self?.backgroundView.image = image
        }
    }
    
    func undo() {
        guard let undoManager = undoManager, undoManager.canUndo else {
            return
        }
        undoManager.undo()
    }
    
    func redo() {
        guard let undoManager = undoManager else { return }
        guard undoManager.canRedo else { return }
        
        undoManager.redo()
    }
    
    func pen() {
        canvasView.tool = _pen
    }
    
    func erase() {
        canvasView.tool = _eraser
    }
}

// MARK: - Private Method

extension PKCanvasControlable {
    private var _pen: PKInkingTool {
        return PKInkingTool(
            .pen,
            color: .black,
            width: 10
        )
    }
    private var _eraser: PKEraserTool {
        return PKEraserTool(.bitmap)
    }
    private var directoryUrl: URL? {
        if !self.isStub {
            let urls = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask
            )
            return urls.first?.appendingPathComponent("PKCanvasControlable.data")
        }
        return FileManager.default.temporaryDirectory
    }
    private var queue: DispatchQueue {
        return DispatchQueue(
            label: "PKCanvasControlable.Queue",
            qos: .background
        )
    }
    private func _add(completion: @escaping ImagePicker.ImagePickerCompletion) {
        guard let presentViewController = self.presentViewController else { return }
        
        ImagePicker().present(
            to: presentViewController,
            completion: completion
        )
    }
    
    private func setUndoCanvas(_ newDrawing: PKDrawing) {
        guard let undoManager = undoManager else { return }
        guard undoManager.canUndo else { return }
        
        let oldDrawing = canvasView.drawing
        undoManager.registerUndo(withTarget: self, handler: { (controlable) in
            controlable.setUndoCanvas(oldDrawing)
        })
        canvasView.drawing = newDrawing
    }
    
    private func setUndoBackgroundImage(_ newImage: UIImage?) {
        guard let undoManager = undoManager else { return }
        
        let oldImage = backgroundView.image
        undoManager.registerUndo(withTarget: self, handler: { (controlable) in
            controlable.setUndoBackgroundImage(oldImage)
        })
        backgroundView.image = newImage
    }
    
}

// MARK: - Prviate Alert Method

extension PKCanvasControlable {
    private func toastMessage() {
        guard let presentViewController = self.presentViewController else { return }
        
        DispatchQueue.main.async {
            UIButton().then {
                $0.setTitle("그림이 저장되었습니다.", for: .normal)
                $0.setTitleColor(.white, for: .normal)
                $0.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                $0.clipsToBounds = true
                $0.layer.cornerRadius = 10
                $0.titleLabel?.lineBreakMode = .byWordWrapping
                $0.contentEdgeInsets = .init(
                    top: 0, left: 10, bottom: 0, right: 10
                )
                $0.addTarget(
                    $0,
                    action: #selector(UIButton.removeFromSuperview),
                    for: .touchUpInside
                )
                presentViewController.view.addSubview($0)
                $0.snp.makeConstraints { (m) in
                    m.centerX.equalToSuperview()
                    m.bottom.equalTo(presentViewController.view.safeAreaLayoutGuide.snp.bottom).inset(20)
                }
            }.do { toastBtn in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    let animations: () -> Void = {
                        toastBtn.alpha = 0
                    }
                    let completion: (Bool) -> Void = { _ in
                        toastBtn.removeFromSuperview()
                    }
                    UIView.animate(
                        withDuration: 1.0,
                        animations: animations,
                        completion: completion
                    )
                }
            }
        }
    }
    
    private func alertMessage() {
        guard let presentViewController = self.presentViewController else { return }
        
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "저장된 그림이 없습니다.",
                message: nil,
                preferredStyle: .alert
            )
            let okAction = UIAlertAction(
                title: "확인",
                style: .default, handler: nil
            )
            alert.addAction(okAction)
            presentViewController.present(
                alert,
                animated: true,
                completion: nil
            )
        }
    }
}
