//
//  MediaViewController.swift
//  DemoPlayer
//
//  Created by Chandan Singh on 10/8/16.
//  Copyright © 2016 Chandan Singh. All rights reserved.
//

import UIKit
import MediaPlayer

class MediaViewController: UIViewController{
    
    var mpPlayer: MPMoviePlayerController = MPMoviePlayerController()
    var myTimer : NSTimer!
    var overlayVC : PlayerOverlayVC!
    var url : NSURL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMoviePlayer()
        
        /* Register for Playing video MPMoviePlayer DidChangeNotification */
        NSNotificationCenter.defaultCenter().addObserverForName(MPMoviePlayerNowPlayingMovieDidChangeNotification, object: nil, queue: NSOperationQueue.mainQueue()) { _ in
            self.setTimer()
        }
        
        /* Register for Playing video MPMoviePlayer FinishNotification */
        NSNotificationCenter.defaultCenter().addObserverForName(MPMoviePlayerPlaybackDidFinishNotification, object: nil, queue: NSOperationQueue.mainQueue()) { _ in
            self.myTimer.invalidate()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // Layout subviews manually
        mpPlayer.view.frame = view.bounds
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.addOverlayView()
        mpPlayer.play() // Start the playback
    }
    
    override func viewWillDisappear(animated: Bool) {
        mpPlayer.stop() // Stop the playback
        self.overlayVC.removeFromParentViewController() // remove overlay
    }
    
    // MARK: OverlayVC initialization
    func addOverlayView() {
        overlayVC = self.storyboard?.instantiateViewControllerWithIdentifier("AVPlayerOverlayVC") as! PlayerOverlayVC
        self.addChildViewController(overlayVC)
        self.view.addSubview(overlayVC.view)
        overlayVC.deleget = self
        overlayVC.didMoveToParentViewController(self)
    }
    
    // MARK: MPMoviePlayerController initialization
    func setupMoviePlayer() {
        mpPlayer = MPMoviePlayerController(contentURL:self.url)
        mpPlayer.movieSourceType = MPMovieSourceType.Unknown
        mpPlayer.view.frame = self.view.bounds
        mpPlayer.scalingMode = MPMovieScalingMode.AspectFit
        mpPlayer.controlStyle = MPMovieControlStyle.None
        mpPlayer.shouldAutoplay = true
        mpPlayer.backgroundView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(mpPlayer.view)
        mpPlayer.prepareToPlay()
    }
    
    // MARK: NSTimer initialization
    func setTimer()  {
        /* schedule timer */
        myTimer = NSTimer.scheduledTimerWithTimeInterval(0, target: self, selector: #selector(MediaViewController.updateTimer(_:)), userInfo: nil, repeats: true)
    }
    
    
    func updateTimer(timer: NSTimer) {
        /* The Total duration of the video player */
        let  totalDuration = Float(mpPlayer.duration)
        /* The current state of the video player */
        let currentDuration = Float(mpPlayer.currentPlaybackTime)
        overlayVC.didTapedSwitch(totalDuration, currentDuration: currentDuration)
    }
}

// MARK: - PlayerOverlayVCDelegate
extension MediaViewController : PlayerOverlayVCDelegate{
    
    func didPlayButtonSelected(isplayorPouse : Bool!){
        if isplayorPouse == true {
            self.setTimer()
            mpPlayer.play() // Start the playback
        }
        else {
            self.myTimer.invalidate()
            mpPlayer.pause() // Pause the playback
        }
    }
    
    func didVideoSliderSliderValueChanged(totalDuration :Double!){
        //update
        mpPlayer.currentPlaybackTime = totalDuration
    }
}
