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
    
    final class StubPKCanvas: UIView, PKCanvasControlable {
        var presentViewController: BaseViewController?
        var backgroundView: UIImageView = StubPKCanvas.initBackgroundView()
        var canvasView: PKCanvasView = StubPKCanvas.initCanvas()
        let isStub: Bool = true
    }
    
    var canvas: StubPKCanvas!
    
    override func setUpWithError() throws {
        canvas = StubPKCanvas()
        let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow })!
        window.addSubview(canvas)
    }

    override func tearDownWithError() throws {
        canvas.removeFromSuperview()
        canvas = nil
    }
    
    func test_undo() {
        let mockNewDrawing = self.makeMockDrawing()
        self.setUndoCanvas(mockNewDrawing)
        canvas.canvasView.drawing = mockNewDrawing
        
        let prevDrawingCount = canvas.canvasView.drawing.strokes.count
        
        canvas.undo()
        
        let currentDrawingCount = canvas.canvasView.drawing.strokes.count
        XCTAssertNotEqual(prevDrawingCount, currentDrawingCount)
    }
    
    func test_redo() {
        test_undo()
        
        let prevDrawing = canvas.canvasView.drawing
        
        canvas.redo()
        
        let currentDrawing = canvas.canvasView.drawing
        XCTAssertNotEqual(prevDrawing, currentDrawing)
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

// MARK: - Make Mock Helper Method

extension PKCanvasControlableTests {
    private func makeMockDrawing() -> PKDrawing {
        var newDrawingStrokes = [PKStroke]()
        let newPoint = PKStrokePoint(
            location: .zero,
            timeOffset: .init(1),
            size: CGSize(width: 5,height: 5),
            opacity: CGFloat(1),
            force: .init(1),
            azimuth: .init(1),
            altitude: .init(1)
        )
        let newPath = PKStrokePath(controlPoints: [newPoint], creationDate: Date())
        newDrawingStrokes.append(PKStroke(ink: PKInk(.pen, color: .black), path: newPath))
        return PKDrawing(strokes: newDrawingStrokes)
    }
    
    private func setUndoCanvas(_ newDrawing: PKDrawing) {
        guard let undoManager = canvas.undoManager else { return }
        
        let oldDrawing = canvas.canvasView.drawing
        undoManager.registerUndo(withTarget: self, handler: { (controlable) in
            controlable.setUndoCanvas(oldDrawing)
        })
        canvas.canvasView.drawing = newDrawing
    }
    
}
