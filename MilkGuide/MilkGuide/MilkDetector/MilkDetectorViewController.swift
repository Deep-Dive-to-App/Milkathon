//
//  ViewController.swift
//  MilkGuide
//
//  Created by 박희지 on 2021/06/26.
//

import UIKit
import AVFoundation

class MilkDetectorViewController: UIViewController {
    @IBOutlet weak var cameraButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // 카메라로 전환되는 액션 함수
    @IBAction func cameraButtonTapped(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Camera", bundle: nil)
        let cameraVC = storyBoard.instantiateViewController(identifier: "CameraViewController") as! CameraViewController
        cameraVC.modalPresentationStyle = .fullScreen
        present(cameraVC, animated: false, completion: nil)
    }
}


