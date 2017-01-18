//
//  ChooseOptionViewController.swift
//  DemoPlayer
//
//  Created by Chandan Singh on 10/8/16.
//  Copyright © 2016 Chandan Singh. All rights reserved.
//

import UIKit


class ViewController: UITableViewController {
    
    var playerListArray = PlayerListData().getPlayerList()

    override func viewDidLoad(){
        super.viewDidLoad()
          /* Remove extra separators */
        tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return playerListArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let playList = playerListArray[indexPath.row]
        cell.textLabel?.text = playList.name
        return cell
    }
    
    // MARK: - Table view deleget
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.performSegue(withIdentifier: "choseController", sender:indexPath)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Pass the selected object to the new view controller
        if segue.identifier == "choseController"{
            let indexPath = sender as! IndexPath
            let playList = playerListArray[indexPath.row]
            let  targetController = segue.destination as! ChoseTableViewController
            targetController.selectPlayer = playList.identifier
        }
    }
}





