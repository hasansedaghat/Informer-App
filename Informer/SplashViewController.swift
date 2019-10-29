//
//  SplashViewController.swift
//  Informer
//
//  Created by Hasan Sedaghat on 10/20/19.
//  Copyright © 2019 Hasan Sedaghat. All rights reserved.
//

import UIKit
import AVKit

class SplashViewController: UIViewController {
    
    @IBOutlet var videoView: UIView!
    @IBOutlet var logo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.playVideo()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "login")
            viewController.modalTransitionStyle = .crossDissolve
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: false, completion: nil)
        }
    }
    
    private func playVideo() {
        guard let path = Bundle.main.path(forResource: "Day", ofType:"mp4") else {
            print("Day.mp4 not found")
            return
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let layer: AVPlayerLayer = AVPlayerLayer(player: player)
        layer.frame = self.view.bounds
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.videoView.layer.addSublayer(layer)
        self.videoView.alpha = 0
        player.play()
        UIView.animate(withDuration: 0.6, animations: {
            self.videoView.alpha = 1
        })
    }
}
