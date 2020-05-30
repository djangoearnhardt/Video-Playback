//
//  PlaybackViewController.swift
//  AVPlayerLayer Video Playback
//
//  Created by Sam LoBue on 5/23/20.
//  Copyright © 2020 DjangoEarnhardt. All rights reserved.
//

import AVFoundation
import UIKit

class PlayVideoViewController: UIViewController {
    
    // MARK: OUTLETS
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var halfSpeedButton: UIButton!
    @IBOutlet weak var threeFourthsSpeedButton: UIButton!
    
    // MARK: PROPERTIES
    var videoURL: URL?
    
    // MARK: LIFECYCLE
    override func viewWillAppear(_ animated: Bool) {
        self.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint(videoView!)
//        presentPlaybackView()
//        debugPrint(videoURL!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loadView()
        presentPlaybackView()
    }
    
    // MARK: ACTIONS
    @IBAction func playButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func pauseButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func stopButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func halfSpeedButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func threeFourthsSpeedButtonTapped(_ sender: Any) {
        
    }
    
    // MARK: HELPER FUNCTIONS
    func presentPlaybackView() {
        guard let videoURL = videoURL else { return }
        
        let asset = AVAsset(url: videoURL)
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
//        playbackView.player = AVPlayer(playerItem: playerItem)
        
//        playbackView.player?.play()
        
        //3. Create AVPlayerLayer object
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = videoView.bounds
        playerLayer.videoGravity = .resizeAspectFill
//        
//        //4. Add playerLayer to view's layer
        videoView.layer.addSublayer(playerLayer)
        
        //5. Play Video
        player.play()
    }
}
