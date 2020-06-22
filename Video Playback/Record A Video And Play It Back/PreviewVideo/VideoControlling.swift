//
//  VideoPreviewControlling.swift
//  Playback A Recorded Video
//
//  Created by Sam LoBue on 6/1/20.
//  Copyright © 2020 DjangoEarnhardt. All rights reserved.
//

import UIKit

/// VideoPreviewViewWithControls Delegate. Allow delegation of a preview layer, UISlider, and UIButtons.
protocol VideoControlling: class {
    func didTapButton(title: String)
    func didTapSlider(value: Float)
    var previewVideoView: PreviewVideoView { get set }
}
