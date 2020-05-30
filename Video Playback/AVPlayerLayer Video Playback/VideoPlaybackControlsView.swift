//
//  VideoPlaybackControlsView.swift
//  AVPlayerLayer Video Playback
//
//  Created by Sam LoBue on 5/24/20.
//  Copyright © 2020 DjangoEarnhardt. All rights reserved.
//

import UIKit

class VideoPlaybackControlsView: UIView {
    
    //FIXME: Would love to get playbackSliderView integrated with this, but had trouble w/ NSLayoutConstraints
    /*
      -------------------------------------------------
     |          |           |          | - 1/2 Speed - |
     | - Play - | - Pause - | - Stop - |---------------|
     |          |           |          | - 3/4 Speed - |
      -------------------------------------------------
     */
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        constructSubviews()
        constructSubviewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var videoPlaybackControlsDelegate: VideoPlaybackControlsDelegate? // Delegate video playback controls, on button taps
    weak var videoPlaybackControlsFavoritesDelegate: VideoPlaybackControlsFavoritesDelegate? // Delegate video playback control favorites, on button taps
    
    // Stackview for all of Controls
    private let horizontalStackView: UIStackView = {
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = NSLayoutConstraint.Axis.horizontal
        horizontalStackView.distribution = .fillEqually
        return horizontalStackView
    }()
    
    private let playButton: UIButton = {
        let playButton = UIButton()
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playButton.tintColor = .systemTeal
        playButton.titleLabel?.text = PlaybackControls.play
        playButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return playButton
    }()
    
    private let pauseButton: UIButton = {
        let pauseButton = UIButton()
        pauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        pauseButton.tintColor = .systemTeal
        pauseButton.titleLabel?.text = PlaybackControls.pause
        pauseButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return pauseButton
    }()
    
    private let favoriteButton: UIButton = {
        let favoriteButton = UIButton()
        favoriteButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        favoriteButton.tintColor = .systemTeal
        favoriteButton.titleLabel?.text = PlaybackControls.favorite
        favoriteButton.addTarget(self, action: #selector(favoritesButtonTapped), for: .touchUpInside)
        return favoriteButton
    }()
    
    // Stackview for speed controls
    private let verticalStackView: UIStackView = {
        let verticalStackView = UIStackView()
        verticalStackView.axis = NSLayoutConstraint.Axis.vertical
        verticalStackView.distribution = .fillEqually
        return verticalStackView
    }()
    
    private let halfSpeedButton: UIButton = {
        let halfSpeedButton = UIButton(type: .system)
        halfSpeedButton.setTitle(PlaybackControls.halfSpeed, for: .normal) // Allow tappable interfact
        halfSpeedButton.tintColor = .systemTeal
        halfSpeedButton.titleLabel?.textAlignment = .center
        halfSpeedButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return halfSpeedButton
    }()
    
    private let threeFourthsSpeedButton: UIButton = {
        let threeFourthsSpeedButton = UIButton(type: .system)
        threeFourthsSpeedButton.setTitle(PlaybackControls.threeFourthsSpeed, for: .normal) // Allow tappable interface
        threeFourthsSpeedButton.tintColor = .systemTeal
        threeFourthsSpeedButton.titleLabel?.textAlignment = .center
        threeFourthsSpeedButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return threeFourthsSpeedButton
    }()
    
    func constructSubviews() {
        // Add the buttons to the horizontalStackView, add the speed buttons to the verticalStackView, add the verticalStackView to the horizontalStackView, then add horizontalStackView to the subviews
        horizontalStackView.addArrangedSubview(playButton)
        horizontalStackView.addArrangedSubview(pauseButton)
        horizontalStackView.addArrangedSubview(favoriteButton)
        verticalStackView.addArrangedSubview(halfSpeedButton)
        verticalStackView.addArrangedSubview(threeFourthsSpeedButton)
        horizontalStackView.addArrangedSubview(verticalStackView)
        addSubview(horizontalStackView)
    }
    
    func constructSubviewConstraints() {
        let views = [horizontalStackView, playButton, pauseButton, favoriteButton, verticalStackView, halfSpeedButton, threeFourthsSpeedButton]
        // Allow to specify autolayout constraints by setting .translatesAutoresizingMaskIntoConstraints to false
        views.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        // horizontalStackView hugs entire VideoPlaybackControlsView
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: self.topAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        // playButton
        NSLayoutConstraint.activate([
            playButton.topAnchor.constraint(equalTo: horizontalStackView.topAnchor),
            playButton.leadingAnchor.constraint(equalTo: horizontalStackView.leadingAnchor),
            playButton.bottomAnchor.constraint(equalTo: horizontalStackView.bottomAnchor)
        ])
        
        // pauseButton
        NSLayoutConstraint.activate([
            pauseButton.leadingAnchor.constraint(equalTo: playButton.trailingAnchor)
        ])
        
        // stopButton
        NSLayoutConstraint.activate([
            favoriteButton.leadingAnchor.constraint(equalTo: pauseButton.trailingAnchor)
        ])
        
        // verticalStackView
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: horizontalStackView.topAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: favoriteButton.trailingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: horizontalStackView.trailingAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: horizontalStackView.bottomAnchor)
        ])
        
        // halfSpeedButton
        NSLayoutConstraint.activate([
            halfSpeedButton.topAnchor.constraint(equalTo: verticalStackView.topAnchor),
            halfSpeedButton.leadingAnchor.constraint(equalTo: verticalStackView.leadingAnchor),
            halfSpeedButton.trailingAnchor.constraint(equalTo: verticalStackView.trailingAnchor)
        ])
        
        // threeFourthsButton
        NSLayoutConstraint.activate([
            threeFourthsSpeedButton.topAnchor.constraint(equalTo: halfSpeedButton.bottomAnchor),
            threeFourthsSpeedButton.leadingAnchor.constraint(equalTo: verticalStackView.leadingAnchor),
            threeFourthsSpeedButton.trailingAnchor.constraint(equalTo: verticalStackView.trailingAnchor),
            threeFourthsSpeedButton.bottomAnchor.constraint(equalTo: verticalStackView.bottomAnchor)
        ])
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text else { return }
        videoPlaybackControlsDelegate?.didTapButton(title: title)
    }
    
    @objc private func favoritesButtonTapped(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text else { return }
        videoPlaybackControlsFavoritesDelegate?.didTapFavoritesButton(title: title)
        favoriteButton.setImage(UIImage(systemName: "bookmark.fill"), for: .highlighted)
    }
}
