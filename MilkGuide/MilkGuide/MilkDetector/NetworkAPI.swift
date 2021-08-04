//
//  networkAPI.swift
//  MilkGuide
//
//  Created by 박희지 on 2021/08/01.
//

import Foundation
import UIKit
import Alamofire

// 바디 파라미터: {"file": filename}
// response: {"class_name": string}
class networkAPI {

    static func requestClassification(_ image: UIImage) -> String {
        let url = "http://57e8bb56e407.ngrok.io"
        let imageData = image.jpegData(compressionQuality: 0.5)!
        var prediction = ""
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "file", fileName: "milk.jpg", mimeType: "image/jpg")
        }, to: url).responseJSON { response in
            print(" 리스폰스: \(response)")
            switch response.result {
            case .success(let value):
                print("성공 시 밸류: \(value)")
                do {
                    let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                    prediction = try JSONDecoder().decode(Result.self, from: data).prediction
                } catch let error {
                    print("----------파싱에러-------------")
                    print(error)
                }
                
            case .failure(let error):
                print("----------failure------------> \(error)")
                prediction = "네트워크 실패"
            }
        }
        return prediction
    }
    
}

struct Result: Codable {
    let prediction: String
        
    enum CodeK: String, CodingKey {
        case prediction = "class_name"
    }
}
