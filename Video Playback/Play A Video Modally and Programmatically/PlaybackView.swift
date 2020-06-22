//
//  PlaybackView.swift
//  AVPlayerLayer Video Playback
//
//  Created by Sam LoBue on 5/23/20.
//  Copyright © 2020 DjangoEarnhardt. All rights reserved.
//

import UIKit
import AVFoundation

class PlaybackView: UIView {
    var player: AVPlayer? {
        get {
            return playbackLayer.player
        }
        set {
            playbackLayer.player = newValue
        }
    }
    
    var playbackLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    // Override UIView property
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}
