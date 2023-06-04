//
//  MainViewController.swift
//  CornLeafDiesesHelper
//
//  Created by Oğuzhan Can on 25.05.2023.
//

import UIKit

class MainViewController: UIViewController {
    var firstRun = true

    
    let imagePredictor = ImagePredictor()

    let predictionsToShow = 1

    @IBOutlet weak var startupPrompts: UIStackView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var predictionLabel: UILabel!
    
}

extension MainViewController {

    @IBAction func camera(_ sender: UIBarButtonItem) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            present(photoPicker, animated: false)
            return
        }

        present(cameraPicker, animated: false)
    }

    /// The method the storyboard calls when the user two-finger taps the screen.
    @IBAction func doubleTap() {
        present(photoPicker, animated: false)
    }
}

extension MainViewController {
    func updateImage(_ image: UIImage) {
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }

    //Update prodection Label
    func updatePredictionLabel(_ message: String) {
        DispatchQueue.main.async {
            self.predictionLabel.text = message
        }

        if firstRun {
            DispatchQueue.main.async {
                self.firstRun = false
                self.predictionLabel.superview?.isHidden = false
                self.startupPrompts.isHidden = true
            }
        }
    }
    //State the view controller when photo came from camera
    func userSelectedPhoto(_ photo: UIImage) {
        updateImage(photo)
        updatePredictionLabel("Making predictions for the photo...")

        DispatchQueue.global(qos: .userInitiated).async {
            self.classifyImage(photo)
        }
    }
    @IBAction func ButtonTapped(_ sender: UIButton) {
        if let name = predictionLabel.text {
            performSegue(withIdentifier: "YoutubeShowVideoSegue", sender: name)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "YoutubeShowVideoSegue" {
             if let destinationVC = segue.destination as? YoutubeViewController, let name = sender as? String {
                 destinationVC.navigationItem.title = name
             }
         }
    }
}

extension MainViewController {

    //Clasify Photo
    private func classifyImage(_ image: UIImage) {
        do {
            try self.imagePredictor.makePredictions(for: image,
                                                    completionHandler: imagePredictionHandler)
        } catch {
            print("Vision was unable to make a prediction...\n\n\(error.localizedDescription)")
        }
    }

    private func imagePredictionHandler(_ predictions: [ImagePredictor.Prediction]?) {
        guard let predictions = predictions else {
            updatePredictionLabel("No predictions. (Check console log.)")
            return
        }

        let formattedPredictions = formatPredictions(predictions)

        let predictionString = formattedPredictions.joined(separator: "\n")
        updatePredictionLabel(predictionString)
    }

    //Convert predection to String
    private func formatPredictions(_ predictions: [ImagePredictor.Prediction]) -> [String] {
        let topPredictions: [String] = predictions.prefix(predictionsToShow).map { prediction in
            var name = prediction.classification

            if let firstComma = name.firstIndex(of: ",") {
                name = String(name.prefix(upTo: firstComma))
            }

            return "\(name) - \(prediction.confidencePercentage)%"
        }

        return topPredictions
    }
}
