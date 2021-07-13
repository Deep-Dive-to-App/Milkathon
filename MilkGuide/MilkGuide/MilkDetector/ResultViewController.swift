//
//  ResultViewController.swift
//  MilkGuide
//
//  Created by 박희지 on 2021/06/26.
//

import UIKit
import CoreML
import Vision
import ImageIO

class ResultViewController: UIViewController {
    let viewModel = ResultViewModel()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var goHomeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        // Do any additional setup after loading the view.
    }
    
    func updateUI() {
        if let info = viewModel.classificationInfo {
            imageView.image = info.image
            resultLabel.text = info.result
        }
    }
    @IBAction func homeButtonTapped(_ sender: Any) {
        let mainTapBarC = self.storyboard?.instantiateViewController(identifier: "MainTabBarController") as! MainTabBarController
        mainTapBarC.modalPresentationStyle = .fullScreen
        present(mainTapBarC, animated: false, completion: nil)
    }
}

// MARK: - Result ViewModel
class ResultViewModel {
    var classificationInfo: ClassificationInfo?
    
    func update(model: ClassificationInfo?) {
        classificationInfo = model
    }
}

