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

protocol PKCanvasControlable: class {
    var presentViewController: BaseViewController? { get }
    var backgroundView: UIImageView { get }
    var canvasView: PKCanvasView { get }
    var cacheDrawing: PKDrawing? { get set }
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
        let drawing = canvasView.drawing
        guard !drawing.bounds.isEmpty,
              cacheDrawing != drawing else {
            return
        }
        
        guard let url = _directoryUrl else { return }
        
        queue.async {
            let imageData = self.backgroundView.image?.jpegData(compressionQuality: 1.0)
            let imageEncodedString = imageData?.base64EncodedString()
            
            let model = CanvasModel(
                backgroundImageEncodedString: imageEncodedString,
                drawing: drawing
            )
            
            do {
                let data = try model.encode()
                try data.write(to: url)
                self.cacheDrawing = drawing
                self._toast()
            } catch {
                print("CanvasModel Save 실패 : \(error)")
            }
        }
    }
    
    func load() {
        guard let url = _directoryUrl else { return }
        
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
                        self.canvasView.drawing = model.drawing
                    }
                } catch {
                    print("CanvasModel Load 실패 : \(error)")
                }
            } else {
                self._alert()
            }
        }
    }
    
    func add() {
        self._add() { [weak backgroundView] (image) in
            backgroundView?.image = image
        }
    }
    
    func undo() {
        canvasView.undoManager?.undo()
    }
    
    func redo() {
        canvasView.undoManager?.redo()
    }
    
    func pen() {
        canvasView.tool = _pan
    }
    
    func erase() {
        canvasView.tool = _eraser
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
    private var _directoryUrl: URL? {
        let urls = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )
        return urls.first?.appendingPathComponent("PKCanvasControlable.data")
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
}

// MARK: - Prviate Helper Method

extension PKCanvasControlable {
    private func _toast() {
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
    
    private func _alert() {
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
