//
//  ViewController.swift
//  Video Playback
//
//  Created by Sam LoBue on 5/23/20.
//  Copyright © 2020 DjangoEarnhardt. All rights reserved.
//

import AVKit
import UIKit

class ViewController: UIViewController {

    // MARK: OUTLETS
    
    // MARK: PROPERTIES
    let audioSession = AVAudioSession.sharedInstance()
    
    // MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    // MARK: ACTIONS
    @IBAction func playVideoButtonTapped(_ sender: Any) {
        playVideo()
    }
    
    // MARK: FUNCTIONS
    func setUp() {
        do {
            try audioSession.setCategory(.playback, mode: .moviePlayback)
        }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
    }
    
    func playVideo() {
        guard let url = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_adv_example_hevc/master.m3u8") else {
            return
        }
        // Create an AVPlayer, passing it the HTTP Live Streaming URL.
        let player = AVPlayer(url: url)
        
        // Create a new AVPlayerViewController and pass it a reference to the player.
        let controller = AVPlayerViewController()
        controller.player = player
        
        // Modally present the player and call the player's play() method when complete.
        // This prevents the play rate from going below 1/2.
//        playerItem.audioTimePitchAlgorithm = AVAudioTimePitchAlgorithmLowQualityZeroLatency;
        
        present(controller, animated: true) {
            player.play()
        }
    }
}

