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
    var  url : NSURL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAVplayer() //initialization AVPlayer
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.addOverlayView()
        avPlayer.play() // Start the playback
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        avPlayerLayer.frame = view.bounds // Layout subviews manually
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.avPlayer.pause() //Pause  the playback
        self.overlayVC.removeFromParentViewController() //Remove overlay
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: AvPlayer initialization
    func setupAVplayer()  {
        
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        view.layer.insertSublayer(avPlayerLayer, atIndex: 0)
        let playerItem = AVPlayerItem(URL:self.url)
        avPlayer.replaceCurrentItemWithPlayerItem(playerItem)
        /* Observer for playing video */
        avPlayer.addPeriodicTimeObserverForInterval(CMTimeMake(1, 60), queue: dispatch_get_main_queue()) {
            [unowned self] time in
            self.updateProgressBar()
        }
    }
    
    // MARK: OverlayVC initialization
    func addOverlayView() {
        overlayVC = self.storyboard?.instantiateViewControllerWithIdentifier("AVPlayerOverlayVC") as! PlayerOverlayVC
        self.addChildViewController(overlayVC)
        self.view.addSubview(overlayVC.view)
        overlayVC.deleget = self
        overlayVC.didMoveToParentViewController(self)
    }
    
    // MARK: Update Vedio Sldier on OverlayVC View
    func updateProgressBar() {
        
        /** The current state of the video player */
        let duration = CMTimeGetSeconds(avPlayer.currentItem!.duration)
        if  !isnan(duration) {
            let totalDuration = Float(duration)
            let  currentDuration = Float(CMTimeGetSeconds(avPlayer.currentTime()))
            overlayVC.didTapedSwitch(totalDuration, currentDuration: currentDuration)
        }
    }
}

// MARK: - PlayerOverlayVCDelegate
extension AVViewController : PlayerOverlayVCDelegate{
    
    func didVideoSliderSliderValueChanged(totalDuration :Double!){
        
        let timeStart = totalDuration
        let timeScale = avPlayer.currentItem!.asset.duration.timescale
        let seektime = CMTimeMakeWithSeconds(timeStart, timeScale)
        if CMTIME_IS_VALID(seektime) {
            avPlayer.seekToTime(seektime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        }
    }
    
    func didPlayButtonSelected(isplayorPouse : Bool!){
        if (isplayorPouse == true) {
            avPlayer.play() // Start the playback
        }
        else {
            avPlayer.pause() // Stop the playback
        }
    }
}

