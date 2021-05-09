// Created by Ina Statkic in 2021.

import Vision

final class VisionModel {
    /// The ML model to be used for recognition of arbitrary objects.
    private var _objectModel: YOLOv3TinyInt8LUT!
    var objectModel: YOLOv3TinyInt8LUT! {
        get {
            if let model = _objectModel { return model }
            _objectModel = {
                do {
                    let configuration = MLModelConfiguration()
                    return try YOLOv3TinyInt8LUT(configuration: configuration)
                } catch {
                    fatalError("Couldn't create Inceptionv3 due to: \(error)")
                }
            }()
            return _objectModel
        }
    }
}
