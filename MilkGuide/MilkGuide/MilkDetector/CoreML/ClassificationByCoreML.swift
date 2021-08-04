//
//  CoreML.swift
//  MilkGuide
//
//  Created by 박희지 on 2021/08/01.
//

import Foundation
import UIKit
import CoreML
import Vision
import ImageIO

class ClassificationByCoreML {
    var prediction = "" {
        didSet {
            let imgClassificationVC = ImageClassificationViewController()
            imgClassificationVC.updateResult(prediction)
        }
    }
    
    // MARK: - Image Classification
    /// - Tag: MLModelSetup
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: my_network().model)
            
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
            
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    /// - Tag: PerformRequests
    func updateClassifications(for image: UIImage) {
        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) form \(image)") }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([self.classificationRequest])       // handler로 model에게 request
            } catch {
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
    /// - Tag: ProcessClassification
    func processClassifications(for request: VNRequest, error: Error?) {
        guard let results = request.results else {
            self.prediction = "분류 불가"
            return
        }
//            let classifications = results as! [VNClassificationObservation]
            let classifications = results as! [VNCoreMLFeatureValueObservation]
            if classifications.isEmpty {
                self.prediction =  "알 수 없음"
                return
            } else {
                /// VNClassificationObservation processing
//                let topClassification = classifications.prefix(1)
//                let prediction = topClassification.first?.identifier
                
                /// VNCoreMLFeatureValueObservation processing
                let topClassification = classifications.first?.featureValue.multiArrayValue
                var maxValue: Float32 = 0
                var prediction = ""
                for i in 0..<topClassification!.count {
                    
                    if maxValue < topClassification![i].floatValue {
                        
                        maxValue = topClassification![i].floatValue
                        prediction = String(i)
                    }
                }
//                print(classifications.description)
//                print(topClassification)
                self.prediction = prediction
            
        }
    }
}
