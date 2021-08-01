//
//  networkAPI.swift
//  MilkGuide
//
//  Created by 박희지 on 2021/08/01.
//

import Foundation
import UIKit
import Alamofire

// 바디 파라미터: {"image": filename}
// response: {"class_name": string}
class networkAPI {
    static func requestClassification(_ image: UIImage) {
        let url = "http://067aae530435.ngrok.io"
        let imageData = image.jpegData(compressionQuality: 0.5)!
        
        AF.upload(multipartFormData: { multipartFormData in
//            multipartFormData.append(Data("value".utf8), withName: "Key")
            multipartFormData.append(imageData,withName: "image",fileName: "milk.jpg", mimeType: "image/jpg")
        }, to: url).responseJSON { response in
            print(response)
        }
        
    }
}
