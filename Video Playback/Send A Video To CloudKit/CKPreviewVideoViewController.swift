//
//  CKPreviewVideoViewController.swift
//  Send A Video To CloudKit
//
//  Created by Sam LoBue on 6/24/20.
//  Copyright © 2020 DjangoEarnhardt. All rights reserved.
//

import AVFoundation
import CloudKit
import Photos
import UIKit

class CKPreviewVideoViewController: UIViewController {
    
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        // Send notification to dismiss the blur effect
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "modalIsDimissed"), object: nil)
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
        let asset = AVAsset(url: videoURL.preparedForVideoPlayback())
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        previewVideoView.player = player
        previewVideoView.videoPreviewLayer.videoGravity = .resizeAspect

        // Add an observer to the player to find the current video duration, and have activityIndicator stop animating
        previewVideoView.player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        
        // Add an observer to the player to track progress in real time
        let interval = CMTime(value: 1, timescale: 2)
        previewVideoView.player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { progressTime in
            
            // Set the progressLabel to track time
            let seconds = progressTime.seconds
            let secondsText = String(format: "%02d", Int(seconds) % 60)
            let minutesText = String(format: "%02d", Int(seconds) / 60)
            self.durationLabel.text = "\(minutesText):\(secondsText)"
            
            // MARK: TODO: videoSlider progress is really choppy, can I make this smoother
            // Set the progress slider to follow time
            if let duration = self.previewVideoView.player?.currentItem?.duration {
                let durationSeconds = duration.seconds
                self.previewVideoViewWithControls.videoSlider.value = (Float(seconds / durationSeconds))
            }
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

extension CKPreviewVideoViewController: VideoControlling {
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
            print("Play tapped")
            previewVideoView.player?.play()
        case PlaybackControls.pause:
            previewVideoView.player?.pause()
        case PlaybackControls.delete:
            print("delete button tapped")
        case PlaybackControls.submit:
            guard let videoURL = VideoRecordingController.sharedInstance.videoURL else { return }
            let videoAsset = CKAsset(fileURL: videoURL)
            let video = Video.Result(name: "TestVideo", videoAsset: videoAsset)
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    VideoRecordingController.sharedInstance.save(video: video) { (result) in
                        self.cleanup(videoURL: videoURL)
                    }
                }
            }
        default:
            print("playback controls button not found")
        }
    }
    
    func didTapSlider(value: Float) {
        if let duration = previewVideoView.player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let sliderAndSecondsValue = Float64(value) * totalSeconds // rename this
            let seekTime = CMTime(value: Int64(sliderAndSecondsValue), timescale: 1)
            
            previewVideoView.player?.seek(to: seekTime, completionHandler: { completedSeek in
                print("completedSeek: \(completedSeek)")
            })
        }
    }
}

// MARK: CLEANUP
extension CKPreviewVideoViewController {
    func cleanup(videoURL: URL) {
        let path = videoURL.path
        if FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.removeItem(atPath: path)
                debugPrint("File Manager removed item atPath: \(path)")
            } catch {
                print("Could not remove file at url: \(videoURL)")
            }
        }
    }
}

// MARK: PREPARE URL FOR VIDEO PLAYBACK
extension URL {
    /// A CKAsset needs Data from it's URL, and a local place to store itself for video playback
    func preparedForVideoPlayback() -> URL {
        // Create videoData from URL
        let videoData = NSData(contentsOf: self)
        // Find a location to save video to
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let destinationPath = documentsPath.appending("/filename.MOV")
        FileManager.default.createFile(atPath: destinationPath,contents:videoData as Data?, attributes:nil)
        let fileURL = NSURL(fileURLWithPath: destinationPath)
        // Return URL to preview video
        return fileURL as URL
    }
}
