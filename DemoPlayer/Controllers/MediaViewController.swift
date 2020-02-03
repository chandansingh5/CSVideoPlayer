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
    var myTimer : Timer!
    var overlayVC : PlayerOverlayVC!
    var url : URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMoviePlayer()
        
        /* Register for Playing video MPMoviePlayer DidChangeNotification */
        NotificationCenter.default.addObserver(forName: NSNotification.Name.MPMoviePlayerNowPlayingMovieDidChange, object: nil, queue: OperationQueue.main) { _ in
            self.setTimer()
        }
        
        /* Register for Playing video MPMoviePlayer FinishNotification */
        NotificationCenter.default.addObserver(forName: NSNotification.Name.MPMoviePlayerPlaybackDidFinish, object: nil, queue: OperationQueue.main) { _ in
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addOverlayView()
        mpPlayer.play() // Start the playback
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mpPlayer.stop() // Stop the playback
        self.overlayVC.removeFromParent() // remove overlay
    }
    
    // MARK: OverlayVC initialization
    func addOverlayView() {
        overlayVC = self.storyboard?.instantiateViewController(withIdentifier: "AVPlayerOverlayVC") as! PlayerOverlayVC
        self.addChild(overlayVC)
        self.view.addSubview(overlayVC.view)
        overlayVC.deleget = self
        overlayVC.didMove(toParent: self)
    }
    
    // MARK: MPMoviePlayerController initialization
    func setupMoviePlayer() {
        mpPlayer = MPMoviePlayerController(contentURL:self.url)
        mpPlayer.movieSourceType = MPMovieSourceType.unknown
        mpPlayer.view.frame = self.view.bounds
        mpPlayer.scalingMode = MPMovieScalingMode.aspectFit
        mpPlayer.controlStyle = MPMovieControlStyle.none
        mpPlayer.shouldAutoplay = true
        mpPlayer.backgroundView.backgroundColor = UIColor.clear
        self.view.addSubview(mpPlayer.view)
        mpPlayer.prepareToPlay()
    }
    
    // MARK: NSTimer initialization
    func setTimer()  {
        /* schedule timer */
        myTimer = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(MediaViewController.updateTimer(_:)), userInfo: nil, repeats: true)
    }
    
    
    @objc func updateTimer(_ timer: Timer) {
        /* The Total duration of the video player */
        let  totalDuration = Float(mpPlayer.duration)
        /* The current state of the video player */
        let currentDuration = Float(mpPlayer.currentPlaybackTime)
        overlayVC.didTapedSwitch(totalDuration, currentDuration: currentDuration)
    }
}

// MARK: - PlayerOverlayVCDelegate
extension MediaViewController : PlayerOverlayVCDelegate{
    
    func didPlayButtonSelected(_ isplayorPouse : Bool!){
        if isplayorPouse == true {
            self.setTimer()
            mpPlayer.play() // Start the playback
        }
        else {
            self.myTimer.invalidate()
            mpPlayer.pause() // Pause the playback
        }
    }
    
    func didVideoSliderSliderValueChanged(_ totalDuration :Double!){
        //update
        mpPlayer.currentPlaybackTime = totalDuration
    }
}
