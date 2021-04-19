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
        canvasView.setup(self)
    }
    
}

// MARK: - Binding

extension MainViewController: StoryboardView {
    func bind(reactor: MainViewReactor) {
        saveBtn.rx.tap
            .subscribe(onNext: { [weak canvasView] (_) in
                canvasView?.save()
            }).disposed(by: disposeBag)
        loadBtn.rx.tap
            .subscribe(onNext: { [weak canvasView] (_) in
                canvasView?.load()
            }).disposed(by: disposeBag)
        addBtn.rx.tap
            .subscribe(onNext: { [weak canvasView] (_) in
                canvasView?.add()
            }).disposed(by: disposeBag)
        undoBtn.rx.tap
            .subscribe(onNext: { [weak canvasView] (_) in
                canvasView?.undo()
            }).disposed(by: disposeBag)
        redoBtn.rx.tap
            .subscribe(onNext: { [weak canvasView] (_) in
                canvasView?.redo()
            }).disposed(by: disposeBag)
        penBtn.rx.tap
            .subscribe(onNext: { [weak canvasView] (_) in
                canvasView?.pen()
            }).disposed(by: disposeBag)
        eraseBtn.rx.tap
            .subscribe(onNext: { [
                weak canvasView, weak coordinator
            ] (_) in
                canvasView?.erase()
                coordinator?.coordinateToNextAny()
            }).disposed(by: disposeBag)
    }
}
