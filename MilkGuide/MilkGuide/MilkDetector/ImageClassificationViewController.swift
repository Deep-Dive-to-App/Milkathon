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
    
    // 분류 결과 update
    func updateResult(_ prediction: String) {
        switch prediction {
        case "0":
            self.result = "딸기우유"
        case "1":
            self.result = "바나나우유"
        case "2":
            self.result = "초코우유"
        case "3":
            self.result = "커피우유"
        case "4":
            self.result = "흰우유"
        default:
            self.result = prediction
        }
        
        DispatchQueue.main.async {
            let resultVC = self.storyboard?.instantiateViewController(identifier: "ResultViewController") as! ResultViewController
            let classificationInfo = ClassificationInfo(image: self.image!, result: self.result)
            resultVC.viewModel.update(model: classificationInfo)
            resultVC.modalPresentationStyle = .fullScreen
            
            self.present(resultVC, animated: false, completion: nil)
        }
        
    }
    
    // CoreML로 우유 분류하기
    func requestByCoreML(_ image: UIImage) {
        self.image = image
        let classification = ClassificationByCoreML()
        classification.updateClassifications(for: image)
        let prediction = classification.prediction
    }
    
    // 네트워크 통신을 통한 우유 분류하기
    func requestByNetwork(_ image: UIImage) {
        self.image = image
//        self.updateResult()
        
    }
}
