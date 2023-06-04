//
//  VNClassificationObservation+confidenceString.swift
//  CornLeafDiesesHelper
//
//  Created by Oğuzhan Can on 25.05.2023.
//


import Vision

extension VNClassificationObservation {
//  in this Extention i generate the string for see the percentange of image.
//  This 'VNClassificationObservation' already exist but i made some uppgrate.
    var confidencePercentageString: String {
        let percentage = confidence * 100
        
        switch percentage {
            case 100.0...:
                return "100%"
            case 10.0..<100.0:
                return String(format: "%2.1f", percentage)
            case 1.0..<10.0:
                return String(format: "%2.1f", percentage)
            case ..<1.0:
                return String(format: "%1.2f", percentage)
            default:
                return String(format: "%2.1f", percentage)
        }
    }
}
