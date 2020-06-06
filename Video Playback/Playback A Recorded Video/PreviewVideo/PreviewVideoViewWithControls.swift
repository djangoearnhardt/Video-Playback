//
//  VideoPreviewViewWithControls.swift
//  Playback A Recorded Video
//
//  Created by Sam LoBue on 5/31/20.
//  Copyright © 2020 DjangoEarnhardt. All rights reserved.
//

import UIKit

class PreviewVideoViewWithControls: UIView {
    
    /*
     ------------------------------------------------
    |                                                |
    |                            - Duration Label -  | // MARK: TODO - Add this
    |                                                |
    |            - Preview Video View -              |
    |                                                |
     ------------------------------------------------
    | -----------------  Slider  --------------------|
     ------------------------------------------------
    |          |           |            |            |
    | - Play - | - Pause - | - Delete - | - Submit - |
    |          |           |            |            |
     ------------------------------------------------
    */
    
    // MARK: PROPERTIES
    weak var videoControlling: VideoControlling? // Preview controls delegate
    
    enum Layout {
        static let padding: CGFloat = 20
    }
    
    public var previewVideoView: PreviewVideoView = {
        let previewVideoView = PreviewVideoView()
        return previewVideoView
    }()
    
    private let videoSlider: UISlider = {
       let videoSlider = UISlider()
        videoSlider.minimumValue = 0
        videoSlider.maximumValue = 1
        videoSlider.minimumTrackTintColor = .white
        videoSlider.maximumTrackTintColor = .systemTeal
        videoSlider.isContinuous = true
        videoSlider.addTarget(self, action: #selector(sliderValueDidChange), for: .valueChanged)
        return videoSlider
    }()
    
    private let horizontalStackView: UIStackView = {
       let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal // maybe replace with .horizontal
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
    
    private let deleteButton: UIButton = {
        let deleteButton = UIButton()
        deleteButton.setImage(UIImage(systemName: "delete.left.fill"), for: .normal)
        deleteButton.tintColor = .systemTeal
        deleteButton.titleLabel?.text = PlaybackControls.delete
        deleteButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return deleteButton
    }()
    
    private let submitButton: UIButton = {
        let submitButton = UIButton()
        submitButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        submitButton.tintColor = .systemTeal
        submitButton.titleLabel?.text = PlaybackControls.submit
        submitButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return submitButton
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
        horizontalStackView.addArrangedSubview(playButton)
        horizontalStackView.addArrangedSubview(pauseButton)
        horizontalStackView.addArrangedSubview(deleteButton)
        horizontalStackView.addArrangedSubview(submitButton)
        addSubview(previewVideoView)
        addSubview(videoSlider)
        addSubview(horizontalStackView)
    }
    
    func constructSubviewConstraints() {
        let views = [previewVideoView, videoSlider, horizontalStackView, playButton, pauseButton, deleteButton, submitButton]
        
        views.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        // videoPreviewView
        NSLayoutConstraint.activate([
            previewVideoView.topAnchor.constraint(equalTo: self.topAnchor),
            previewVideoView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            previewVideoView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
        
        // videoSlider
        NSLayoutConstraint.activate([
            videoSlider.topAnchor.constraint(equalTo: previewVideoView.bottomAnchor),
            videoSlider.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            videoSlider.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            videoSlider.bottomAnchor.constraint(equalTo: horizontalStackView.topAnchor, constant: -Layout.padding)
        ])
        
        // horizontalStackView
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: videoSlider.bottomAnchor, constant: Layout.padding),
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
        
        // deleteButton
        NSLayoutConstraint.activate([
            deleteButton.leadingAnchor.constraint(equalTo: pauseButton.trailingAnchor)
        ])
        
        // submitButton
        NSLayoutConstraint.activate([
            submitButton.leadingAnchor.constraint(equalTo: deleteButton.trailingAnchor)

        ])
    }
    
    // MARK: DELEGATE FUNCTIONS
    @objc private func buttonTapped(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text else { return }
        videoControlling?.didTapButton(title: title)
    }
    
    @objc private func sliderValueDidChange(_ sender: UISlider) {
        videoControlling?.didTapSlider(value: sender.value)
    }
}
