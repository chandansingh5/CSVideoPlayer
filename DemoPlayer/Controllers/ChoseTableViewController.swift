//
//  ChoseTableViewController.swift
//  DemoPlayer
//
//  Created by Chandan Singh on 10/10/16.
//  Copyright © 2016 Chandan Singh. All rights reserved.
//

import UIKit

class ChoseTableViewController: UITableViewController {

    var videoListArray = [VideoList]()
    var selectPlayer : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()   /* Remove extra separators */
        if selectPlayer == "vlcController" {
            /* VLC support video list */
            videoListArray =  VideoSectionsData().getVLCPlayListFArrayFromData()
        }else{
            /* AvPlayer support video list */
            videoListArray = VideoSectionsData().getAVPlayerPlayListArrayFromData()
        }
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return videoListArray.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoListArray[section].items.count
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return videoListArray[section].heading
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        // Configure the cell...
        let urlString = videoListArray[indexPath.section].items[indexPath.row]
        let fullNameArr : [String] = urlString.componentsSeparatedByString("/")
        let lastName : String = fullNameArr.last!
        cell.textLabel?.text = lastName
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        var url : NSURL!
        
        if indexPath.section == 0 {
            let urlString = videoListArray[indexPath.section].items[indexPath.row]
            let (firstName,lastName ) = CommonMethods.separatedByString(".", fulname: urlString)
            let videoFile = NSBundle.mainBundle().pathForResource(firstName, ofType: lastName)
            url = NSURL(fileURLWithPath: videoFile!)
        }else {
            url = NSURL(string:videoListArray[indexPath.section].items[indexPath.row])!
        }
        if (url != nil)  {
            self.performSegueWithIdentifier(selectPlayer as String, sender:url)
        }
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let url  = sender as! NSURL
        if segue.identifier == "avController"{
            let  targetController = segue.destinationViewController as! AVViewController
            targetController.url = url
        }else if segue.identifier == "mpController" {
            let targetController = segue.destinationViewController as! MediaViewController
            targetController.url = url
        }else if segue.identifier == "vlcController" {
            let targetController = segue.destinationViewController as! VLCViewController
            targetController.url = url
        }
    }
}



