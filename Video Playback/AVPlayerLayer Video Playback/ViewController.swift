//
//  ViewController.swift
//  AVPlayerLayer Video Playback
//
//  Created by Sam LoBue on 5/23/20.
//  Copyright © 2020 DjangoEarnhardt. All rights reserved.
//

import AVFoundation
import UIKit

class ViewController: UIViewController {
    
    // MARK: OUTLETS
    @IBOutlet weak var videoView: UIView!
    
    // MARK: PROPERTIES
    var url: URL = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_adv_example_hevc/master.m3u8")!
    
    // MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: ACTIONS
    @IBAction func playCurrentVCButtonTapped(_ sender: Any) {
        playVideoOnCurrentViewController()
    }
    
    @IBAction func playModalButtonTapped(_ sender: Any) {
        playVideoWithModal()
    }
    
    @IBAction func programmaticPlaybackButtonTapped(_ sender: Any) {
        programmaticPlayback()
    }
    // MARK: HELPER FUNCTIONS
    func playVideoOnCurrentViewController() {
        //1. Create a URL
        if let url = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_adv_example_hevc/master.m3u8") {
            //2. Create AVPlayer object
            let asset = AVAsset(url: url)
            let playerItem = AVPlayerItem(asset: asset)
            let player = AVPlayer(playerItem: playerItem)
            
            //3. Create AVPlayerLayer object
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.videoView.bounds
            playerLayer.videoGravity = .resizeAspectFill
            
            //4. Add playerLayer to view's layer
            self.videoView.layer.addSublayer(playerLayer)
            
            //5. Play Video
            player.play()
        }
    }
    
    func playVideoWithModal() {
        performSegue(withIdentifier: "toVideoVC", sender: nil)
//        if let url = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_adv_example_hevc/master.m3u8") {
//            guard let videoVC = UIViewController() as? VideoViewController else { return }
//            guard let destinationVC = UIViewController() as? PlayVideoViewController else { return }
//            destinationVC.videoURL = url
//            performSegue(withIdentifier: "toPlaybackVC", sender: nil)
//            present(destinationVC, animated: true, completion: nil)
//        } else {
//            debugPrint("ERROR")
//        }
}
    
    func programmaticPlayback() {
        let vc = ProgrammaticViewController()
        vc.videoURL = url
        present(vc, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let url = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_adv_example_hevc/master.m3u8")
        if segue.identifier == "toVideoVC" {
            guard let destinationVC = segue.destination as? PlayVideoViewController else { return }
            destinationVC.videoURL = url
        }
    }
}
