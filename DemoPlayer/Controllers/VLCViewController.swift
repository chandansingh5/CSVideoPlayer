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
    var url : URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addMovieView()
        self.setupVLCPalyer()
        /* Register for start PlayerTime video notification */
       NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: VLCMediaPlayerTimeChanged), object: nil, queue: OperationQueue.main) { _ in
            self .timechangedLoadStateDidChange()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addOverlayView()
        vlcMediaPlayer.play() // Start the playback
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        vlcMediaPlayer.stop() // Stop the playback
        overlayVC.removeFromParent() // Remove overlay
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
        overlayVC = self.storyboard?.instantiateViewController(withIdentifier: "AVPlayerOverlayVC") as! PlayerOverlayVC
        self.addChild(overlayVC)
        self.view.addSubview(overlayVC.view)
        overlayVC.deleget = self
        overlayVC.didMove(toParent: self)
    }
    
    // MARK: - MovieeView initializatio
    func addMovieView()  {
        self.movieView = UIView()
        self.movieView.backgroundColor = UIColor.gray
        self.movieView.frame = UIScreen.screens[0].bounds
    }
    
    // MARK: - VlcMediaPlayer initializatio
    func setupVLCPalyer()  {
        vlcMediaPlayer.delegate = self
        vlcMediaPlayer.drawable = self.movieView
        vlcMediaPlayer.media = VLCMedia(url:self.url)
        self.view.addSubview(self.movieView)
    }
}

// MARK: - PlayerOverlayVCDelegate

extension VLCViewController :PlayerOverlayVCDelegate {
    
    func didPlayButtonSelected(_ isplayorPouse : Bool!){
        if (vlcMediaPlayer.time.intValue != 0)  {
            if isplayorPouse == true {
                vlcMediaPlayer.play() // Start the playback
            }
            else {
                vlcMediaPlayer.pause() // Pauser the playback
            }
        }
    }
    
    
    func didVideoSliderSliderValueChanged(_ currrentDuration :Double!){
        
        let range = Float(self.vlcMediaPlayer.media.length.value)/100
        let perCent = (Float(currrentDuration) / range)
        self.vlcMediaPlayer.position = Float (perCent)
        
    }
}
