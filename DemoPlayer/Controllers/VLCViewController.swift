//
//  VLCViewController.swift
//  DemoPlayer
//
//  Created by Chandan Singh on 10/8/16.
//  Copyright © 2016 Chandan Singh. All rights reserved.
//

import UIKit

class VLCViewController: UIViewController,VLCMediaPlayerDelegate {
    
    var vlcMediaPlayer = VLCMediaPlayer()
    var overlayVC : PlayerOverlayVC!
    var movieView: UIView!
    var url : NSURL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addMovieView()
        self.setupVLCPalyer()
        /* Register for start PlayerTime video notification */
       NSNotificationCenter.defaultCenter().addObserverForName(VLCMediaPlayerTimeChanged, object: nil, queue: NSOperationQueue.mainQueue()) { _ in
            self .timechangedLoadStateDidChange()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.addOverlayView()
        vlcMediaPlayer.play() // Start the playback
    }
    
    override func viewWillDisappear(animated: Bool) {
        vlcMediaPlayer.stop() // Stop the playback
        overlayVC.removeFromParentViewController() // Remove overlay
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        /* Layout subviews manually */
        self.movieView.frame = self.view.frame
    }
    
    func timechangedLoadStateDidChange() {
        
        /* The Total duration of the video player */
        guard let grandtotal = self.vlcMediaPlayer.media.length.value else {
            return
        }
        /* The current state of the video player */
        guard let guardcurrent = vlcMediaPlayer.time.value else {
            return
        }
        let total   = Float(grandtotal) / 100
        let current = Float(guardcurrent) / 100
        overlayVC.didTapedSwitch(total, currentDuration:current)
    }
    
    // MARK: - PlayerOverlayVC initialization
    func addOverlayView() {
        overlayVC = self.storyboard?.instantiateViewControllerWithIdentifier("AVPlayerOverlayVC") as! PlayerOverlayVC
        self.addChildViewController(overlayVC)
        self.view.addSubview(overlayVC.view)
        overlayVC.deleget = self
        overlayVC.didMoveToParentViewController(self)
    }
    
    // MARK: - MovieeView initializatio
    func addMovieView()  {
        self.movieView = UIView()
        self.movieView.backgroundColor = UIColor.grayColor()
        self.movieView.frame = UIScreen.screens()[0].bounds
    }
    
    // MARK: - VlcMediaPlayer initializatio
    func setupVLCPalyer()  {
        vlcMediaPlayer.delegate = self
        vlcMediaPlayer.drawable = self.movieView
        vlcMediaPlayer.media = VLCMedia(URL:self.url)
        self.view.addSubview(self.movieView)
    }
}

// MARK: - PlayerOverlayVCDelegate

extension VLCViewController :PlayerOverlayVCDelegate {
    
    func didPlayButtonSelected(isplayorPouse : Bool!){
        if (vlcMediaPlayer.time.intValue != 0)  {
            if isplayorPouse == true {
                vlcMediaPlayer.play() // Start the playback
            }
            else {
                vlcMediaPlayer.pause() // Pauser the playback
            }
        }
    }
    
    
    func didVideoSliderSliderValueChanged(currrentDuration :Double!){
        
        let range = Float(self.vlcMediaPlayer.media.length.value)/100
        let perCent = (Float(currrentDuration) / range)
        self.vlcMediaPlayer.position = Float (perCent)
        
    }
}