//
//  PreviewView.swift
//  MilkGuide
//
//  Created by 박희지 on 2021/06/26.
//

import UIKit
import AVFoundation

class previewView: UIView {
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        guard let layer = layer as? AVCaptureVideoPreviewLayer else {
            fatalError("Expected `AVCaptureVideoPreviewLayer` type for layer. Check PreviewView.layerClass implemention.")
        }
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        layer.connection?.videoOrientation = .portrait
        return layer
    }
    
    var session: AVCaptureSession? {
        get {
            return videoPreviewLayer.session
        }
        set {
            videoPreviewLayer.session = newValue
        }
    }
    
    // MARK: - UIView
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
}
