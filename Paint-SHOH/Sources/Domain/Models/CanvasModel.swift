//
//  CanvasModel.swift
//  Paint-SHOH
//
//  Created by Oh Sangho on 2021/04/20.
//

import Foundation
import PencilKit

struct CanvasModel: Codable {
    let backgroundImageEncodedString: String?
    let drawing: PKDrawing
}
