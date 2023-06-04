//
//  CGImagePropertyOrientation+UIImageOrientation.swift
//  CornLeafDiesesHelper
//
//  Created by Oğuzhan Can on 25.05.2023.
//

import UIKit
import ImageIO

extension CGImagePropertyOrientation {
//  in this class i made orientation the image.The image came from user camera but we need the convert that image to another type for mlmodel can handle that image.This 'CGImagePropertyOrientation' already exist but i made some uppgrate.
    init(_ orientation: UIImage.Orientation) {
        switch orientation {
            case .up: self = .up
            case .down: self = .down
            case .left: self = .left
            case .right: self = .right
            case .upMirrored: self = .upMirrored
            case .downMirrored: self = .downMirrored
            case .leftMirrored: self = .leftMirrored
            case .rightMirrored: self = .rightMirrored
            @unknown default: self = .up
        }
    }
}
