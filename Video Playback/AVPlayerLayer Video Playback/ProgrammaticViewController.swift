//
//  ProgrammaticViewController.swift
//  AVPlayerLayer Video Playback
//
//  Created by Sam LoBue on 5/24/20.
//  Copyright © 2020 DjangoEarnhardt. All rights reserved.
//

import AVFoundation
import UIKit

class ProgrammaticViewController: UIViewController {
    // MARK: TODO https://www.youtube.com/watch?v=HX1aYzaHex8 and youtube folder for slider progress
    // https://www.letsbuildthatapp.com/course_video?id=282
    // Have video controls sit on top of view, and opacity for it... as well as some type of background and opacity for durationlabel
    // MARK: PROPERTIES
    let playbackSlider: PlaybackSliderView = PlaybackSliderView()
    let playbackView: PlaybackView = PlaybackView()
    var videoURL: URL?
    var videoTimestamps: [CMTime] = []
    let videoPlaybackControlsView: VideoPlaybackControlsView = VideoPlaybackControlsView()
    
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
        static let leadingAndTrailingMargin: CGFloat = 25
    }
    
    // MARK: VIEWCYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.self.backgroundColor = .black
        view.addSubview(playbackView)
        view.addSubview(playbackSlider)
        view.addSubview(videoPlaybackControlsView)
        view.addSubview(durationLabel)
        view.addSubview(activityIndicatorView)
        constructSubviewConstraints()
        setupVideoForPlayback()
        playbackSlider.playbackSliderControlDelegate = self // adopt delegate for sliderView
        videoPlaybackControlsView.videoPlaybackControlsDelegate = self // adopt delegate for video controls
        videoPlaybackControlsView.videoPlaybackControlsFavoritesDelegate = self // adopt delegate for favorites

    }
    
    // MARK: HELPER FUNCTIONS
    func constructSubviewConstraints() {
        let views = [durationLabel, activityIndicatorView, playbackView, playbackSlider, videoPlaybackControlsView]
        
        // Allow to specify autolayout constraints by setting .translatesAutoresizingMaskIntoConstraints to false
        views.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        // activityIndicatorView
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: playbackView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: playbackView.centerYAnchor)
        ])
        
        // durationLabel
        NSLayoutConstraint.activate([
            durationLabel.widthAnchor.constraint(equalToConstant: 50),
            durationLabel.topAnchor.constraint(equalTo: playbackView.topAnchor, constant: 20),
            durationLabel.trailingAnchor.constraint(equalTo: playbackView.trailingAnchor, constant: -20)
        ])
        
        // playbackView
        NSLayoutConstraint.activate([
            playbackView.topAnchor.constraint(equalTo: view.topAnchor),
            playbackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playbackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playbackView.bottomAnchor.constraint(equalTo: playbackView.bottomAnchor)
        ])
        
        // playbackSlider
        NSLayoutConstraint.activate([
            playbackSlider.topAnchor.constraint(equalTo: playbackView.bottomAnchor),
            playbackSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.leadingAndTrailingMargin),
            playbackSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.leadingAndTrailingMargin),
            playbackSlider.bottomAnchor.constraint(equalTo: videoPlaybackControlsView.topAnchor)
        ])
        
        // videoPlaybackControlsView
        NSLayoutConstraint.activate([
            videoPlaybackControlsView.topAnchor.constraint(equalTo: playbackSlider.bottomAnchor),
            videoPlaybackControlsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.leadingAndTrailingMargin),
            videoPlaybackControlsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.leadingAndTrailingMargin),
            videoPlaybackControlsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: VIDEO PLAYBACK
    
    func setupVideoForPlayback() {
        guard let videoURL = videoURL else { return }
        let asset = AVAsset(url: videoURL)
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        playbackView.player = player
        playbackView.playbackLayer.videoGravity = .resizeAspectFill

        // Add an observer to the player to find the current video duration, and have activityIndicator stop animating
        playbackView.player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        
        // Add an observer to the player to track progress in real time
        let interval = CMTime(value: 1, timescale: 2)
        playbackView.player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { progressTime in
            
            // Set the progressLabel to track time
            let seconds = progressTime.seconds
            let secondsText = String(format: "%02d", Int(seconds) % 60)
            let minutesText = String(format: "%02d", Int(seconds) / 60)
            self.durationLabel.text = "\(minutesText):\(secondsText)"
            
            // Set the progress slider to follow time
            if let duration = self.playbackView.player?.currentItem?.duration {
                let durationSeconds = duration.seconds
                // FIXME: Delegate slider value to track along with this time. Need to be able to set playbackSlider.value to (Float(seconds / durationSeconds))
//                sliderthumb? = Float(seconds / durationSeconds)
                
            }
        })
    }
    
    // Section for updating video progress time
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges" {
            activityIndicatorView.stopAnimating()
            
            if let duration = playbackView.player?.currentItem?.duration { // CMTime reference
                let seconds = CMTimeGetSeconds(duration) // Convert CMTime to seconds
                let secondsText = String(format: "%02d", Int(seconds) % 60)
                let minutesText = String(format: "%02d", Int(seconds) / 60)
//                durationLabel.text = "\(minutesText):\(secondsText)"
            }
        }
    }
    
    func playFrom(timeStamp: CMTime) {
        playbackView.player?.seek(to: timeStamp)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: EXTENSIONS
extension ProgrammaticViewController: VideoPlaybackControlsDelegate {
    
    func didTapButton(title: String) {
        switch title {
        case PlaybackControls.play:
            playbackView.player?.play()
        case PlaybackControls.pause:
            playbackView.player?.pause()
        case PlaybackControls.halfSpeed:
            playbackView.player?.rate = 0.5
        case PlaybackControls.threeFourthsSpeed:
            playbackView.player?.rate = 0.75
        default:
            print("error")
        }
    }
}

extension ProgrammaticViewController: VideoPlaybackControlsFavoritesDelegate {
    var favorites: [CMTime] {
        get {
            print(videoTimestamps)
            return videoTimestamps
        }
        set {
            videoTimestamps = newValue
        }
    }
    
    func didTapFavoritesButton(title: String) {
        guard let timeStamp = playbackView.player?.currentTime() else { return }
        favorites.append(timeStamp)
        print(favorites.count)
    }
}

extension ProgrammaticViewController: PlaybackSliderControlDelegate {
    func didTapSlider(value: Float) {
        print(value)
        if let duration = playbackView.player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            
            let sliderAndSecondsValue = Float64(value) * totalSeconds // rename this
            
            let seekTime = CMTime(value: Int64(sliderAndSecondsValue), timescale: 1)
            playbackView.player?.seek(to: seekTime, completionHandler: { completedSeek in
                // perhaps something here
                
            })
        }
    }
}
