//
//  MainViewController.swift
//  Paint-SHOH
//
//  Created by Oh Sangho on 2021/04/19.
//

import UIKit
import SnapKit
import ReactorKit
import PencilKit
import RxCocoa

final class MainViewController: BaseViewController {
    
    @IBOutlet private weak var saveBtn: IBButton!
    @IBOutlet private weak var loadBtn: IBButton!
    @IBOutlet private weak var addBtn: IBButton!
    @IBOutlet private weak var undoBtn: IBButton!
    @IBOutlet private weak var redoBtn: IBButton!
    @IBOutlet private weak var penBtn: IBButton!
    @IBOutlet private weak var eraseBtn: IBButton!
    
    @IBOutlet private weak var canvasView: PKCanvas!
    
    var coordinator: MainFlow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        canvasView.setup()
    }
    
}

// MARK: - Binding

extension MainViewController: StoryboardView {
    func bind(reactor: MainViewReactor) {
        saveBtn.rx.tap
            .bind { (_) in
                self.canvasView.save()
            }.disposed(by: disposeBag)
        loadBtn.rx.tap
            .bind { (_) in
                self.canvasView.load()
            }.disposed(by: disposeBag)
        addBtn.rx.tap
            .bind { (_) in
                self.canvasView.add(self)
            }.disposed(by: disposeBag)
        undoBtn.rx.tap
            .bind { (_) in
                self.canvasView.undo()
            }.disposed(by: disposeBag)
        redoBtn.rx.tap
            .bind { (_) in
                self.canvasView.redo()
            }.disposed(by: disposeBag)
        penBtn.rx.tap
            .bind { (_) in
                self.canvasView.pen()
            }.disposed(by: disposeBag)
        eraseBtn.rx.tap
            .bind { (_) in
                self.canvasView.erase()
                self.coordinator?.coordinateToNextAny()
            }.disposed(by: disposeBag)
    }
}
