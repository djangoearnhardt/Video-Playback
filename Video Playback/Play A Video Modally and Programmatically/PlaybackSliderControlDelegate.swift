//
//  PlaybackSliderControlDelegate.swift
//  AVPlayerLayer Video Playback
//
//  Created by Sam LoBue on 5/26/20.
//  Copyright © 2020 DjangoEarnhardt. All rights reserved.
//

import UIKit

/// Allow parent view to handle a PlaybackSliderView's value change
protocol PlaybackSliderControlDelegate: class {
    func didTapSlider(value: Float)
}
