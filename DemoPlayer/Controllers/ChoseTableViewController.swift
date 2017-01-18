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
    override func numberOfSections(in tableView: UITableView) -> Int {
        return videoListArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoListArray[section].items.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return videoListArray[section].heading
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        // Configure the cell...
        let urlString = videoListArray[indexPath.section].items[indexPath.row]
        let fullNameArr : [String] = urlString.components(separatedBy: "/")
        let lastName : String = fullNameArr.last!
        cell.textLabel?.text = lastName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        var url : URL!
        
        if indexPath.section == 0 {
            let urlString = videoListArray[indexPath.section].items[indexPath.row]
            let (firstName,lastName ) = CommonMethods.separatedByString(".", fulname: urlString)
            let videoFile = Bundle.main.path(forResource: firstName, ofType: lastName)
            url = URL(fileURLWithPath: videoFile!)
        }else {
            url = URL(string:videoListArray[indexPath.section].items[indexPath.row])!
        }
        if (url != nil)  {
            self.performSegue(withIdentifier: selectPlayer as String, sender:url)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let url  = sender as! URL
        if segue.identifier == "avController"{
            let  targetController = segue.destination as! AVViewController
            targetController.url = url
        }else if segue.identifier == "mpController" {
            let targetController = segue.destination as! MediaViewController
            targetController.url = url
        }else if segue.identifier == "vlcController" {
            let targetController = segue.destination as! VLCViewController
            targetController.url = url
        }
    }
}



