//
//  VideoPlaybackControlsFavoritesDelegate.swift
//  AVPlayerLayer Video Playback
//
//  Created by Sam LoBue on 5/25/20.
//  Copyright © 2020 DjangoEarnhardt. All rights reserved.
//

import AVFoundation
import Foundation

/// Allow parent view to favorite video clip times, and use those times to start video playback from
protocol  VideoPlaybackControlsFavoritesDelegate: class {
    var favorites: [CMTime] { get set }
    func didTapFavoritesButton(title: String)
}
