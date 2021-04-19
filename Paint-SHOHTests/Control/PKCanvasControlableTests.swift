//
//  PKCanvasControlableTests.swift
//  Paint-SHOHTests
//
//  Created by Oh Sangho on 2021/04/20.
//

import XCTest
@testable import Paint_SHOH
import PencilKit

class PKCanvasControlableTests: XCTestCase {
    
    final class PKCanvasMock: PKCanvasControlable {
        var presentViewController: BaseViewController?
        var backgroundView: UIImageView = PKCanvasMock.initBackgroundView()
        var canvasView: PKCanvasView = PKCanvasMock.initCanvas()
        var cacheDrawing: PKDrawing?
        let isStub: Bool = true
    }
    
    var canvas: PKCanvasMock!
    
    override func setUpWithError() throws {
        canvas = PKCanvasMock()
    }

    override func tearDownWithError() throws {
        canvas = nil
    }
    
    func test_undo() {
        if !canvas.canvasView.undoManager!.canUndo {
            XCTAssertTrue(false)
        } else {
            canvas.undo()
            XCTAssertTrue(true)
        }
    }
    
    func test_redo() {
        if !canvas.canvasView.undoManager!.canRedo {
            XCTAssertTrue(false)
        } else {
            canvas.redo()
            XCTAssertTrue(true)
        }
    }
    
    func test_pen() {
        canvas.pen()
        let penTool = PKInkingTool(
            .pen,
            color: .black,
            width: 10
        )
        XCTAssertTrue(canvas.canvasView.tool as! PKInkingTool == penTool)
    }
    
    func test_erase() {
        canvas.erase()
        let eraserTool = PKEraserTool(.bitmap)
        XCTAssertTrue(canvas.canvasView.tool as! PKEraserTool == eraserTool)
    }
}
