//
//  VideoPlaybackControlsDelegate.swift
//  AVPlayerLayer Video Playback
//
//  Created by Sam LoBue on 5/25/20.
//  Copyright © 2020 DjangoEarnhardt. All rights reserved.
//

import AVFoundation

/// Allow parent view to see which video control button is tapped, and in this use case manipulate PlaybackView's player controls
// Could make this a more generic name for other uses, like ButtonTapDelegate
protocol VideoPlaybackControlsDelegate: class {
    func didTapButton(title: String)
}
