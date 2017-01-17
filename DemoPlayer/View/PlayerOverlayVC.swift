//
//  AVPlayerOverlayVC.swift
//  DemoPlayer
//
//  Created by Chandan Singh on 10/6/16.
//  Copyright © 2016 Chandan Singh. All rights reserved.
//

import AVFoundation
import MediaPlayer;
import AVKit

protocol PlayerOverlayVCDelegate{
    
    func didVideoSliderSliderValueChanged(totalDuration :Double!)
    func didPlayButtonSelected(isplayorPouse : Bool!)
}

class PlayerOverlayVC: UIViewController {
    
    @IBOutlet weak var mpView: MPVolumeView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var playerBarView: UIView!
    @IBOutlet weak var playButton:UIButton!
    @IBOutlet weak var playBigButton:UIButton!
    @IBOutlet weak var volumeButton:UIButton!
    @IBOutlet weak var videoSlider:UISlider!
    @IBOutlet weak var volumeSlider:UISlider!
    @IBOutlet weak var playerBarViewHightContraint: NSLayoutConstraint!
    @IBOutlet weak var remainingDurationLabel: UILabel!
    @IBOutlet weak var currentDurationlLabel: UILabel!
    
    var  playBarAutoideInterval : NSTimeInterval!
    var  isVideoSliderMoving: Bool! = true
    var  isVideoSliderComplete: Bool! = true
    var  volume:MPVolumeView!
    var  mpSlider:UISlider!
    var  deleget : PlayerOverlayVCDelegate!

    var isFullScreen:Bool {
        get {
            return UIApplication.sharedApplication().statusBarOrientation.isLandscape
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.playBarAutoideInterval = 5.0
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isVideoSliderMoving = true
        self.volumeSlider.hidden = true
        self.playBigButton.hidden = true

        self.activityIndicator.startAnimating()
        self.view.layoutIfNeeded()
        
        /* VloumeSlider transform into 90 degree */
        self.volumeSlider.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
        self.volumeSlider.value = AVAudioSession.sharedInstance().outputVolume
      
        /* Tap gesture */
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapGesture))
        self.view.addGestureRecognizer(tap)
        
        self.hidePlayerBar()
        self.setUpAudoBackground()
        self.systemVolume()
       
    }
    
    // MARK: - Actions
    @IBAction func btnVolumeButtonSelected(sender: AnyObject) {
        if volumeSlider.hidden {
            UIView.animateWithDuration(0.25, animations: {() -> Void in
                self.volumeSlider.hidden = false // Show Volume Slider
            })
        }
        else {
            UIView.animateWithDuration(0.25, animations: {() -> Void in
                self.volumeSlider.hidden = true // Hide Volume Slider
            })
        }
        self.autoHidePlayerBar()
    }
    
    @IBAction func btnFullscreenButtonSelected(sender: AnyObject) {
       
        if isFullScreen {
            
            /* Change Portrait Orientaion */
            UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
            UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)
            UIApplication.sharedApplication().setStatusBarOrientation(UIInterfaceOrientation.Portrait, animated: false)
        } else {
            
            /* Change LandscapeRight Orientaion */

            UIDevice.currentDevice().setValue(UIInterfaceOrientation.LandscapeRight.rawValue, forKey: "orientation")
            UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)
            UIApplication.sharedApplication().setStatusBarOrientation(UIInterfaceOrientation.LandscapeRight, animated: false)
        }
    }
    
    @IBAction func btnRestartButtonSelected(sender: AnyObject) {
        
        /* Reset Video With Update OverlayView */
        isVideoSliderMoving = false
        isVideoSliderComplete = true
        self.deleget.didVideoSliderSliderValueChanged(0.1)
        UIView.animateWithDuration(0.25, animations: {
            /* Hide PlayBigbutton On ReStrat */
            self.playBigButton.hidden = true
        })
        self.currentDurationlLabel.text = self.remainingDurationLabel.text
        self.remainingDurationLabel.text = NSString(format: "%.2f",00.00) as String
        self.videoSlider.value = 0.0
        self.btnPlayButtonSelected(false)
    }
    
    @IBAction func btnPlayButtonSelected(sender: AnyObject) {
        
        if (isVideoSliderMoving == true && isVideoSliderComplete == true ) {
            /* Pause */
            self.playButton.selected = true
            isVideoSliderMoving = false
            deleget.didPlayButtonSelected(isVideoSliderMoving)
        }else if (isVideoSliderMoving == false && isVideoSliderComplete == true ){
            /* Play */
            self.playButton.selected = false
            isVideoSliderMoving = true
            deleget.didPlayButtonSelected(isVideoSliderMoving)
        }
        self.autoHidePlayerBar()
    }
    
    // MARK: - Stop VideoSlider
    @IBAction func didVideoSliderTouchDown(sender: AnyObject) {
        self.isVideoSliderMoving = false;
    }
   
    @IBAction func didVideoSliderTouchUp(sender: AnyObject) {
        if (isVideoSliderMoving == false) {
            isVideoSliderComplete = true
            /** The current duration of the VideoSlider */
            let timeStart = Double((sender as! UISlider).value) //
            self.deleget.didVideoSliderSliderValueChanged(timeStart)
        }
        isVideoSliderMoving = true
        self.autoHidePlayerBar()
    }
    
    // Mark: - VolumeSlider
    @IBAction func didVolumeSliderValueChanged(sender: AnyObject) {
        self.playBigButton.hidden = true
        self.mpSlider.value = (sender as! UISlider).value
        self.mpSlider.sendActionsForControlEvents(.TouchUpInside)
        self.autoHidePlayerBar()
    }
    
    
    // Mark: - SystemVolume initialization
    func systemVolume(){
        self.volume = MPVolumeView(frame: mpView.bounds)
        self.volume.showsRouteButton = true
        self.volume.showsVolumeSlider = false
        self.mpView.addSubview(self.volume)
        for view: AnyObject in volume!.subviews {
            if (view is UISlider) {
                self.mpSlider = view as! UISlider
            }
        }
    }
    
    // Mark: - TapOnVideoSlider
    func didTapedSwitch(totalDuration :Float!,currentDuration:Float!){
        
        if isVideoSliderMoving == true {
            var remaingDruation = totalDuration - currentDuration
            if remaingDruation <= 0 {
                /* show Restart Button  After complete Slider */
                isVideoSliderMoving = false
                isVideoSliderComplete = false
                playBigButton.hidden = false
                remaingDruation = 00.00
            }
            self.currentDurationlLabel.text = NSString(format: "%.2f",currentDuration) as String
            self.remainingDurationLabel.text = NSString(format: "%.2f",remaingDruation) as String
            self.videoSlider.maximumValue = totalDuration
            self.videoSlider.value = currentDuration
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidden = true
        }
    }
    
    
    // Mark: - Setup Audio/Video in
    func setUpAudoBackground() {
        let  audioSession = AVAudioSession.sharedInstance()
        do
        {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback, withOptions: .AllowBluetooth)
            try audioSession.setActive(true)
        }
        catch let e
        {
            debugPrint("failed to initialize audio session: \(e)")
        }
    }
    
    // Mark: - Add\Remove PerformSelector
    func autoHidePlayerBar(){
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(self.hidePlayerBar), object: nil) // Cancel privious Request
        self.performSelector(#selector(self.hidePlayerBar), withObject: nil, afterDelay: playBarAutoideInterval!) // Add New Request
    }
    
   
    // Mark: - Hide PlayBarView
    func hidePlayerBar() {
        UIView.animateWithDuration(0.5, animations: {
            self.playerBarViewHightContraint.constant = 0
            self.volumeSlider.hidden = true
            self.playerBarView.hidden = true

        })
    }
    
    // Mark: - Show PlayBarView
    func showPlayerBar() {
       // self.playBigButton.hidden = false
        self.playerBarView.hidden = false
        UIView.animateWithDuration(0.5, animations: {
            self.playerBarViewHightContraint.constant = 50
        })
    }
    
    // Mark: - TapGesture
    func didTapGesture(sender: AnyObject) {
        if playerBarView.hidden {
            self.showPlayerBar()
        }else{
            self.hidePlayerBar()
        }
    }
}
