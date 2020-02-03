//
//  ViewController.swift
//  DemoPlayer
//
//  Created by Chandan Singh on 10/6/16.
//  Copyright © 2016 Chandan Singh. All rights reserved.
//



import AVFoundation
import AVKit

class AVViewController: UIViewController   {
    
    var  overlayVC : PlayerOverlayVC!
    let  avPlayer :AVPlayer = AVPlayer()
    var  avPlayerLayer: AVPlayerLayer!
    var  url : URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAVplayer() //initialization AVPlayer
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addOverlayView()
        avPlayer.play() // Start the playback
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        avPlayerLayer.frame = view.bounds // Layout subviews manually
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.avPlayer.pause() //Pause  the playback
        self.overlayVC.removeFromParent() //Remove overlay
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: AvPlayer initialization
    func setupAVplayer()  {
        
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        view.layer.insertSublayer(avPlayerLayer, at: 0)
        let playerItem = AVPlayerItem(url:self.url)
        avPlayer.replaceCurrentItem(with: playerItem)
        /* Observer for playing video */
        avPlayer.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 60), queue: DispatchQueue.main) {
            [unowned self] time in
            self.updateProgressBar()
        }
    }
    
    // MARK: OverlayVC initialization
    func addOverlayView() {
        overlayVC = self.storyboard?.instantiateViewController(withIdentifier: "AVPlayerOverlayVC") as! PlayerOverlayVC
        self.addChild(overlayVC)
        self.view.addSubview(overlayVC.view)
        overlayVC.deleget = self
        overlayVC.didMove(toParent: self)
    }
    
    // MARK: Update Vedio Sldier on OverlayVC View
    func updateProgressBar() {
        
        /** The current state of the video player */
        let duration = CMTimeGetSeconds(avPlayer.currentItem!.duration)
        let myIntValue:Int = Int(duration)
        
        if  (myIntValue != 0) {
            let totalDuration = Float(duration)
            let  currentDuration = Float(CMTimeGetSeconds(avPlayer.currentTime()))
            overlayVC.didTapedSwitch(totalDuration, currentDuration: currentDuration)
        }
    }
}

// MARK: - PlayerOverlayVCDelegate
extension AVViewController : PlayerOverlayVCDelegate{
    
    func didVideoSliderSliderValueChanged(_ totalDuration :Double!){
        
        let timeStart = totalDuration
        let timeScale = avPlayer.currentItem!.asset.duration.timescale
        let seektime = CMTimeMakeWithSeconds(timeStart!, preferredTimescale: timeScale)
        if CMTIME_IS_VALID(seektime) {
            avPlayer.seek(to: seektime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        }
    }
    
    func didPlayButtonSelected(_ isplayorPouse : Bool!){
        if (isplayorPouse == true) {
            avPlayer.play() // Start the playback
        }
        else {
            avPlayer.pause() // Stop the playback
        }
    }
}

