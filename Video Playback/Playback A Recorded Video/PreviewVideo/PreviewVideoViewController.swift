//
//  PreviewVideoViewController.swift
//  Playback A Recorded Video
//
//  Created by Sam LoBue on 6/9/20.
//  Copyright © 2020 DjangoEarnhardt. All rights reserved.
//

import AVFoundation
import UIKit

class PreviewVideoViewController: UIViewController {

    // MARK: PROPERTIES
    let previewVideoViewWithControls: PreviewVideoViewWithControls = PreviewVideoViewWithControls()
    var videoURL: URL?
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }()
    
    private let durationLabel: UILabel = {
        var durationLabel = UILabel()
        durationLabel.textColor = .white
        durationLabel.text = "00:00"
        durationLabel.textAlignment = .right
        return durationLabel
    }()
    
    enum Layout {
        static let durationLabelMargins: CGFloat = 15
        static let playbackControlMargins: CGFloat = 35
        static let playbackControlBottomMargin: CGFloat = 55
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        adoptDelegates()
        constructSubviewConstraints()
        setupVideoForPlayback()
    }
    
    // MARK: HELPER FUNCTIONS
    func addSubviews() {
        view.addSubview(activityIndicatorView)
        view.addSubview(durationLabel)
        view.addSubview(previewVideoViewWithControls)
    }
    
    func adoptDelegates() {
        previewVideoViewWithControls.videoControlling = self
    }
    
    func constructSubviewConstraints() {
        let views = [activityIndicatorView, durationLabel, previewVideoViewWithControls]
        
        // Allow to specify autolayout constraints by setting .translatesAutoresizingMaskIntoConstraints to false
        views.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        // activityIndicatorView
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: previewVideoViewWithControls.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: previewVideoViewWithControls.centerYAnchor)
        ])
        
        // durationLabel
        NSLayoutConstraint.activate([
            durationLabel.topAnchor.constraint(equalTo: previewVideoViewWithControls.previewVideoView.topAnchor, constant: Layout.durationLabelMargins),
            durationLabel.trailingAnchor.constraint(equalTo: previewVideoViewWithControls.previewVideoView.trailingAnchor)
        ])
        
        // playbackView
        NSLayoutConstraint.activate([
            previewVideoViewWithControls.topAnchor.constraint(equalTo: view.topAnchor),
            previewVideoViewWithControls.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.playbackControlMargins),
            previewVideoViewWithControls.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.playbackControlMargins),
            previewVideoViewWithControls.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Layout.playbackControlBottomMargin)
        ])
    }

    func setupVideoForPlayback() {
            guard let videoURL = videoURL else { return }
            let asset = AVAsset(url: videoURL)
            let playerItem = AVPlayerItem(asset: asset)
            let player = AVPlayer(playerItem: playerItem)
            previewVideoView.player = player
            previewVideoView.videoPreviewLayer.videoGravity = .resizeAspect

            // Add an observer to the player to find the current video duration, and have activityIndicator stop animating
            previewVideoView.player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
            
//             Add an observer to the player to track progress in real time
            let interval = CMTime(value: 1, timescale: 2)
            previewVideoView.player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { progressTime in

                // Set the progressLabel to track time
                let seconds = progressTime.seconds
                let secondsText = String(format: "%02d", Int(seconds) % 60)
                let minutesText = String(format: "%02d", Int(seconds) / 60)
                self.durationLabel.text = "\(minutesText):\(secondsText)"

                // Set the progress slider to follow time
                // FIXME: get a duration label on this page
//                if let duration = self.playbackView.player?.currentItem?.duration {
//                    let durationSeconds = duration.seconds

//                }
            })
        }
        
        // Add an observer to dismiss the activityIndicatorView when the video is loaded
        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == "currentItem.loadedTimeRanges" {
                activityIndicatorView.stopAnimating()
            }
        }

        func convertToMinutesAndSecondsFrom(_ timeStamp: CMTime) -> String {
            let seconds = CMTimeGetSeconds(timeStamp) // Convert CMTime to seconds
            let secondsText = String(format: "%02d", Int(seconds) % 60)
            let minutesText = String(format: "%02d", Int(seconds) / 60)
            return "\(minutesText):\(secondsText)"
        }
}

extension PreviewVideoViewController: VideoControlling {
    var previewVideoView: PreviewVideoView {
        get {
            return previewVideoViewWithControls.previewVideoView
        }
        set {
            previewVideoViewWithControls.previewVideoView = newValue
        }
    }

    func didTapButton(title: String) {
        
        switch title {
        case PlaybackControls.play:
            previewVideoView.player?.play()
            print("play button tapped")
        case PlaybackControls.pause:
            previewVideoView.player?.pause()
            print("pause button tapped")
        case PlaybackControls.delete:
            print("delete button tapped")
        case PlaybackControls.submit:
            print("submit button tapped")
        default:
            print("playback controls button not found")
        }
    }
    
    func didTapSlider(value: Float) {
        print("playback controls button not found")
    }
}
