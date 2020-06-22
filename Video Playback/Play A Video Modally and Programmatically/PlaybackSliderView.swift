//
//  PlaybackSliderView.swift
//  AVPlayerLayer Video Playback
//
//  Created by Sam LoBue on 5/25/20.
//  Copyright © 2020 DjangoEarnhardt. All rights reserved.
//

import UIKit

class PlaybackSliderView: UIView {
    
    //FIXME: Add this view to videoPlaybackControlsView, not sure if these constraints are buggy or when adding to the other view
    /*
     -------------------------------------------------
    | ----------------- (Slider) ---------------------|
     -------------------------------------------------
    */
    
    // MARK: PROPERTIES
    weak var playbackSliderControlDelegate: PlaybackSliderControlDelegate?
    
    // Values for slider ranges
    var minimumValue: CGFloat = 0
    var maximumValue: CGFloat = 1
    var lowerValue: CGFloat = 0.2
    var upperValue: CGFloat = 0.8

    private let playbackSlider: UISlider = {
        let playbackSlider = UISlider()
        playbackSlider.minimumValue = 0
        playbackSlider.maximumValue = 1
        playbackSlider.minimumTrackTintColor = .white
        playbackSlider.maximumTrackTintColor = .systemTeal
        playbackSlider.isContinuous = true
        playbackSlider.addTarget(self, action: #selector(sliderValueDidChange), for: .valueChanged)
        return playbackSlider
    }()
    
    // MARK: LIFECYCLE
    public override init(frame: CGRect) {
        super.init(frame: frame)
        constructSubviews()
        constructSubviewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: HELPER FUNCTIONS
    func constructSubviews() {
        addSubview(playbackSlider)
    }
    
    func constructSubviewConstraints() {
        playbackSlider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            playbackSlider.topAnchor.constraint(equalTo: self.topAnchor),
            playbackSlider.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            playbackSlider.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            playbackSlider.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
 
    // MARK: DELEGATE METHOD
    @objc private func sliderValueDidChange(_ sender: UISlider) {
        playbackSliderControlDelegate?.didTapSlider(value: sender.value)
    }
}
