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
    
    func didVideoSliderSliderValueChanged(_ totalDuration :Double!)
    func didPlayButtonSelected(_ isplayorPouse : Bool!)
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
    
    var  playBarAutoideInterval : TimeInterval!
    var  isVideoSliderMoving: Bool! = true
    var  isVideoSliderComplete: Bool! = true
    var  volume:MPVolumeView!
    var  mpSlider:UISlider!
    var  deleget : PlayerOverlayVCDelegate!

    var isFullScreen:Bool {
        get {
            return UIApplication.shared.statusBarOrientation.isLandscape
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.playBarAutoideInterval = 5.0
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isVideoSliderMoving = true
        self.volumeSlider.isHidden = true
        self.playBigButton.isHidden = true

        self.activityIndicator.startAnimating()
        self.view.layoutIfNeeded()
        
        /* VloumeSlider transform into 90 degree */
        self.volumeSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        self.volumeSlider.value = AVAudioSession.sharedInstance().outputVolume
      
        /* Tap gesture */
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapGesture))
        self.view.addGestureRecognizer(tap)
        
        self.hidePlayerBar()
        self.setUpAudoBackground()
        self.systemVolume()
       
    }
    
    // MARK: - Actions
    @IBAction func btnVolumeButtonSelected(_ sender: AnyObject) {
        if volumeSlider.isHidden {
            UIView.animate(withDuration: 0.25, animations: {() -> Void in
                self.volumeSlider.isHidden = false // Show Volume Slider
            })
        }
        else {
            UIView.animate(withDuration: 0.25, animations: {() -> Void in
                self.volumeSlider.isHidden = true // Hide Volume Slider
            })
        }
        self.autoHidePlayerBar()
    }
    
    @IBAction func btnFullscreenButtonSelected(_ sender: AnyObject) {
       
        if isFullScreen {
            
            /* Change Portrait Orientaion */
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            UIApplication.shared.setStatusBarHidden(false, with: UIStatusBarAnimation.fade)
            UIApplication.shared.setStatusBarOrientation(UIInterfaceOrientation.portrait, animated: false)
        } else {
            
            /* Change LandscapeRight Orientaion */

            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
            UIApplication.shared.setStatusBarHidden(false, with: UIStatusBarAnimation.fade)
            UIApplication.shared.setStatusBarOrientation(UIInterfaceOrientation.landscapeRight, animated: false)
        }
    }
    
    @IBAction func btnRestartButtonSelected(_ sender: AnyObject) {
        
        /* Reset Video With Update OverlayView */
        isVideoSliderMoving = false
        isVideoSliderComplete = true
        self.deleget.didVideoSliderSliderValueChanged(0.1)
        UIView.animate(withDuration: 0.25, animations: {
            /* Hide PlayBigbutton On ReStrat */
            self.playBigButton.isHidden = true
        })
        self.currentDurationlLabel.text = self.remainingDurationLabel.text
        self.remainingDurationLabel.text = NSString(format: "%.2f",00.00) as String
        self.videoSlider.value = 0.0
        self.btnPlayButtonSelected(false as AnyObject)
    }
    
    @IBAction func btnPlayButtonSelected(_ sender: AnyObject) {
        
        if (isVideoSliderMoving == true && isVideoSliderComplete == true ) {
            /* Pause */
            self.playButton.isSelected = true
            isVideoSliderMoving = false
            deleget.didPlayButtonSelected(isVideoSliderMoving)
        }else if (isVideoSliderMoving == false && isVideoSliderComplete == true ){
            /* Play */
            self.playButton.isSelected = false
            isVideoSliderMoving = true
            deleget.didPlayButtonSelected(isVideoSliderMoving)
        }
        self.autoHidePlayerBar()
    }
    
    // MARK: - Stop VideoSlider
    @IBAction func didVideoSliderTouchDown(_ sender: AnyObject) {
        self.isVideoSliderMoving = false;
    }
   
    @IBAction func didVideoSliderTouchUp(_ sender: AnyObject) {
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
    @IBAction func didVolumeSliderValueChanged(_ sender: AnyObject) {
        self.playBigButton.isHidden = true
        self.mpSlider.value = (sender as! UISlider).value
        self.mpSlider.sendActions(for: .touchUpInside)
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
    func didTapedSwitch(_ totalDuration :Float!,currentDuration:Float!){
        
        if isVideoSliderMoving == true {
            var remaingDruation = totalDuration - currentDuration
            if remaingDruation <= 0 {
                /* show Restart Button  After complete Slider */
                isVideoSliderMoving = false
                isVideoSliderComplete = false
                playBigButton.isHidden = false
                remaingDruation = 00.00
            }
            self.currentDurationlLabel.text = NSString(format: "%.2f",currentDuration) as String
            self.remainingDurationLabel.text = NSString(format: "%.2f",remaingDruation) as String
            self.videoSlider.maximumValue = totalDuration
            self.videoSlider.value = currentDuration
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    
    // Mark: - Setup Audio/Video in
    func setUpAudoBackground() {
        let  audioSession = AVAudioSession.sharedInstance()
        do
        {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback, with: .allowBluetooth)
            try audioSession.setActive(true)
        }
        catch let e
        {
            debugPrint("failed to initialize audio session: \(e)")
        }
    }
    
    // Mark: - Add\Remove PerformSelector
    func autoHidePlayerBar(){
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.hidePlayerBar), object: nil) // Cancel privious Request
        self.perform(#selector(self.hidePlayerBar), with: nil, afterDelay: playBarAutoideInterval!) // Add New Request
    }
    
   
    // Mark: - Hide PlayBarView
    func hidePlayerBar() {
        UIView.animate(withDuration: 0.5, animations: {
            self.playerBarViewHightContraint.constant = 0
            self.volumeSlider.isHidden = true
            self.playerBarView.isHidden = true

        })
    }
    
    // Mark: - Show PlayBarView
    func showPlayerBar() {
       // self.playBigButton.hidden = false
        self.playerBarView.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.playerBarViewHightContraint.constant = 50
        })
    }
    
    // Mark: - TapGesture
    func didTapGesture(_ sender: AnyObject) {
        if playerBarView.isHidden {
            self.showPlayerBar()
        }else{
            self.hidePlayerBar()
        }
    }
}
