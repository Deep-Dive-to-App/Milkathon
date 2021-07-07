//
//  SettingViewController.swift
//  MilkGuide
//
//  Created by 박희지 on 2021/07/07.
//

import UIKit
import StoreKit

class SettingViewController: UIViewController {
    enum SettingType: Int, CaseIterable {
        case appVersion
        case description
        case developer
        case rate
        
        var title: String {
            switch self {
            case .appVersion: return "ℹ️ 버전 \(UIApplication.shared.appVersion)"
            case .description: return
                """
                손에 쥐고 있는 이 우유가 어떤 우유인지 쉽게 알기
                어려운 시각장애인 분들을 위하여,
                사진으로 손쉽게 우유 종류를 인식하여 알려주는
                우유 detecting 앱입니다. 🌝
                """
            case .developer: return
                """
                💻 개발자 소개
                💙 지인: 우유 분류 모델 구축
                💚 희지: iOS 앱 구현
                """
            case .rate: return "리뷰를 남겨주세요 🤎"
            }
        }
        
        var height: CGFloat {
            switch self {
            case .description: return 170
            case .developer: return 130
            default: return 74
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let setting = SettingType(rawValue: indexPath.row) else { return 78 }
        
        return setting.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as? SettingCell else {
            return UITableViewCell()
        }
        cell.settingTitle.text = SettingType.allCases[indexPath.row].title
        return cell
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let setting = SettingType(rawValue: indexPath.row) else { return }
        switch setting {
        case .appVersion: break
        case .description: break
        case .developer: break
        case .rate:
            SKStoreReviewController.requestReview()
        }
    }
}

class SettingCell: UITableViewCell {
    @IBOutlet weak var settingTitle: UILabel!
}

extension UIApplication {
    var appVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
    }
}
