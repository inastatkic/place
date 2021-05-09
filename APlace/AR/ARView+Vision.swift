// Created by Ina Statkic in 2021.

import Vision.VNRequest
import UIKit.UIDevice

extension ARViewContainer.Coordinator {
    // Handle completion of the Vision request and choose results to display.
    func processClassifications(for request: VNRequest, error: Error?) {
        guard let results = request.results else {
            print("Unable to classify image.\n\(error!.localizedDescription)")
            return
        }

        let classifications = results as! [VNRecognizedObjectObservation]
        
        // Show a label for the highest-confidence result (but only above a confidence threshold).
        if let bestResult = classifications.first(where: { $0.confidence > 0.7 }),
           let label = bestResult.labels.first {
            print(label)
        }
    }
    
    func classifyCurrentImage() {
        let orientation = CGImagePropertyOrientation(UIDevice.current.orientation)
        
        let requestHandler = VNImageRequestHandler(cvPixelBuffer: currentBuffer!, orientation: orientation)
        visionQueue.async {
            do {
                // Release the pixel buffer when done, allowing the next buffer to be processed.
                defer { self.currentBuffer = nil }
                try requestHandler.perform([self.classificationRequest])
            } catch {
                print("Error: Vision request failed with error \"\(error)\"")
            }
        }
    }
}
