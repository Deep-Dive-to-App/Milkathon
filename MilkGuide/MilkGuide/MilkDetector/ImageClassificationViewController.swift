//
//  ImageClassificationViewController.swift
//  MilkGuide
//
//  Created by 박희지 on 2021/06/26.
//

import UIKit
import CoreML
import Vision
import ImageIO

class ImageClassificationViewController: UIViewController {
    /*
    0 : 딸기우유
    1 : 바나나우유
    2 : 초코우유
    3 : 커피우유
    4 : 흰우유
    */
    var image: UIImage?
    var result: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Image Classification
    /// - Tag: MLModelSetup
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: MilkClassifier().model)
            
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            return request
            
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    /// - Tag: PerformRequests
    func updateClassifications(for image: UIImage) {
        self.image = image
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
    
    /// update UI with the results of the classification.
    /// - Tag: ProcessClassification
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            let resultVC = self.storyboard?.instantiateViewController(identifier: "ResultViewController") as! ResultViewController
            guard let results = request.results else {
                self.result = "분류 불가"
                self.present(resultVC, animated: false, completion: nil)
                return
            }
            let classifications = results as! [VNCoreMLFeatureValueObservation]
            
            if classifications.isEmpty {
                self.result = "알 수 없음"
            } else {
                let topClassification = classifications.prefix(1)
                let max = Int(topClassification[0].featureName)!
                
                switch max {
                case 0:
                    self.result = "딸기우유"
                case 1:
                    self.result = "바나나우유"
                case 2:
                    self.result = "초코우유"
                case 3:
                    self.result = "커피우유"
                case 4:
                    self.result = "흰우유"
                default:
                    self.result = "우유 아님"
                }
            }
            let classificationInfo = ClassificationInfo(image: self.image!, result: self.result)
            resultVC.viewModel.update(model: classificationInfo)
            resultVC.modalPresentationStyle = .fullScreen
            
            self.present(resultVC, animated: false, completion: nil)
            
        }
    }
}
