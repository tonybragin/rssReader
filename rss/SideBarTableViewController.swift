//
//  SideBarTableViewController.swift
//  rss
//
//  Created by TONY on 12/05/2019.
//  Copyright © 2019 TONY. All rights reserved.
//

import UIKit
import SideMenu

class SideBarTableViewController: UITableViewController, mySuperProtocol {
    
    var uiController: UITableViewController!
    var feedController: CoreDataHelper!
    var favorited: Bool = false
    
    private let menu = ["Favorite feeds", "All feeds"]
    
    var indexStart: IndexPath?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        uiController = self
        feedController = CoreDataHelper(rss: RSSHelper())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refresh()
        indexStart = nil
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return menu.count
        } else {
            return feedController.feedList.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as! SideMenuCell
            cell.nameLabel.text = menu[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SideFeedCell", for: indexPath) as! SideFeedCell
            cell.nameLabel.text = feedController.feedList[indexPath.row].name
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 { //menu
            switch indexPath.row {
                case 0:
                    favorited = true
                case 1:
                    favorited = false
                default: break
            }
        } else { //feeds
            indexStart = IndexPath(row: 0, section: indexPath.row)
        }
        
        dismiss(animated: true, completion: nil)
    }

    
}
