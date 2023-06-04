//
//  ImagePredictor.swift
//  CornLeafDiesesHelper
//
//  Created by Oğuzhan Can on 25.05.2023.
//

import Vision
import UIKit

// In this Class guess what is the image be
class ImagePredictor {
    static func createImageClassifier() -> VNCoreMLModel {

        let defaultConfig = MLModelConfiguration()

        let imageClassifierWrapper = try? CornLeafDiseaseHelper(configuration: defaultConfig)
        
        guard let imageClassifier = imageClassifierWrapper else {
            fatalError("Filed to Create Model.")
        }

//      Created instance of model
        let imageClassifierModel = imageClassifier.model

        guard let imageClassifierVisionModel = try? VNCoreMLModel(for: imageClassifierModel) else {
            fatalError("App failed to create a `VNCoreMLModel` instance.")
        }

        return imageClassifierVisionModel
    }
    
    private static let imageClassifier = createImageClassifier()

    struct Prediction {
//      used for see the whic image guess.
        let classification: String
//      used for see the percentange of the image.
        let confidencePercentage: String
    }

    typealias ImagePredictionHandler = (_ predictions: [Prediction]?) -> Void

    private var predictionHandlers = [VNRequest: ImagePredictionHandler]()

    private func createImageClassificationRequest() -> VNImageBasedRequest {

        let imageClassificationRequest = VNCoreMLRequest(model: ImagePredictor.imageClassifier,
                                                         completionHandler: visionRequestHandler)

        imageClassificationRequest.imageCropAndScaleOption = .centerCrop
        return imageClassificationRequest
    }

    func makePredictions(for photo: UIImage, completionHandler: @escaping ImagePredictionHandler) throws {
        let orientation = CGImagePropertyOrientation(photo.imageOrientation)

        guard let photoImage = photo.cgImage else {
            fatalError("Photo doesn't have underlying CGImage.")
        }

        let imageClassificationRequest = createImageClassificationRequest()
        predictionHandlers[imageClassificationRequest] = completionHandler

        let handler = VNImageRequestHandler(cgImage: photoImage, orientation: orientation)
        let requests: [VNRequest] = [imageClassificationRequest]
        
//      here start request for guesing
        try handler.perform(requests)
    }
    private func visionRequestHandler(_ request: VNRequest, error: Error?) {
        guard let predictionHandler = predictionHandlers.removeValue(forKey: request) else {
            fatalError("Every request must have a prediction handler.")
        }

        var predictions: [Prediction]? = nil

        defer {
            predictionHandler(predictions)
        }

        if let error = error {
            print("Vision image classification error...\n\n\(error.localizedDescription)")
            return
        }

        if request.results == nil {
            print("Request had no results.")
            return
        }

        guard let observations = request.results as? [VNClassificationObservation] else {
            print("Wrong result type: \(type(of: request.results)).")
            return
        }

        predictions = observations.map { observation in
            Prediction(classification: observation.identifier,
                       confidencePercentage: observation.confidencePercentageString)
        }
    }
}

