//
//  AlertUtilities.swift
//  ArtScreen
//
//  Created by Heng on 2020/7/30.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

extension UIImage {
    func resized() -> UIImage? {
        let canvasSize = CGSize(width: screenWidth, height: screenWidth)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        let origin = CGPoint(x: 0, y: 0)
        draw(in: CGRect(origin: origin, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension UIImage.Orientation {
    var isLandscape: Bool {
        switch self {
        case .up, .down, .upMirrored, .downMirrored:
            return false
        case .left, .right, .leftMirrored, .rightMirrored:
            return true
        default:
            return false
        }
    }
}

extension CGRect {
    var switched: CGRect {
        return CGRect(x: minY, y: minX, width: height, height: width)
    }
}



