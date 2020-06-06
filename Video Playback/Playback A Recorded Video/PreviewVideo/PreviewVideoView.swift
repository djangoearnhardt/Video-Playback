//
//  PreviewVideoView.swift
//  Playback A Recorded Video
//
//  Created by Sam LoBue on 5/31/20.
//  Copyright © 2020 DjangoEarnhardt. All rights reserved.
//

import AVFoundation
import UIKit

class PreviewVideoView: UIView {
    // Declare videoPreviewLayer as an AVPlayerLayer, which hosts video playback
    var videoPreviewLayer: AVPlayerLayer {
        layer as! AVPlayerLayer
    }
    
    // Set an AVPlayer on the videoPreviewLayer for video playback
    var player: AVPlayer? {
        get {
            return videoPreviewLayer.player
        }
        set {
            videoPreviewLayer.player = newValue
        }
    }

    // Override UIView's default layer type. ie: Let this UIView become a AVPlayer Layer
    override static var layerClass: AnyClass {
        AVPlayerLayer.self
    }
}

