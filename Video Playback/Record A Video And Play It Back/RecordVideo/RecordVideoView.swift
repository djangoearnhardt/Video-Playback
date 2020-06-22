//
//  RecordVideoView.swift
//  Playback A Recorded Video
//
//  Created by Sam LoBue on 5/17/20.
//  Copyright © 2020 DjangoEarnhardt. All rights reserved.
//

import UIKit
import AVFoundation

class RecordVideoView: UIView {
    /// CA layer as AVCaptureVideoPreviewLayer. The live rendering preview of a video recording.
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        guard let videoPreviewLayer = layer as? AVCaptureVideoPreviewLayer else {
            fatalError("Expected `AVCaptureVideoPreviewLayer` type for layer. Check RecordVideoView.layerClass implementation.")
        }
        videoPreviewLayer.videoGravity = .resizeAspectFill // videoPreviewLayer fills entire view area
        return videoPreviewLayer
    }
    
    /// An object that manages capture activity and coordinates the flow of data from input devices to capture outputs.
    var session: AVCaptureSession? {
        get {
            return videoPreviewLayer.session
        }
        set {
            videoPreviewLayer.session = newValue
        }
    }
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
}
