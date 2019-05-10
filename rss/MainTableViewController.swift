//
//  MainTableViewController.swift
//  rss
//
//  Created by TONY on 19/04/2019.
//  Copyright © 2019 TONY. All rights reserved.
//

import UIKit
import FeedKit
import CoreData
import SwiftWebVC

class MainTableViewController: UITableViewController {
    
    var feed = CoreDataHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refresh()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return feed.feedList.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feed.feedItemsList[section].count < 11 ? feed.feedItemsList[section].count + 1 : 11
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 50
        }
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedName", for: indexPath) as! FeedNameCell
            
            cell.nameLabel.text = feed.feedList[indexPath.section].name
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedItem", for: indexPath) as! FeedItemCell
            
            cell.nameItemLabel.text = feed.feedItemsList[indexPath.section][indexPath.row - 1].title
            cell.infoItemLabel.text = feed.feedItemsList[indexPath.section][indexPath.row - 1].description
            return cell
        }
    }
    
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
        refresh()
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        editFeedNameAlert(name: "", url: "")
        refresh()
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 {
            return true
        }
        return false
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editButton = UITableViewRowAction(style: .normal, title: "edit") { (UITableViewRowAction, IndexPath) in
            self.editFeedNameAlert(name: self.feed.feedList[indexPath.section].name!, url: self.feed.feedList[indexPath.section].url!)
            self.refresh()
        }
        editButton.backgroundColor = UIColor.blue
        
        let deleteButton = UITableViewRowAction(style: .destructive, title: "delete") { (UITableViewRowAction, IndexPath) in
            do {
                try self.feed.delete(feed: self.feed.feedList[indexPath.section])
                self.refresh()
            } catch {
                self.alert(title: "error", message: "error delete")
            }
        }
        deleteButton.backgroundColor = UIColor.red
        
        return [deleteButton, editButton]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            let webBrowser = SwiftWebVC(urlString: feed.feedItemsList[indexPath.section][indexPath.row-1].link!)
            self.navigationController?.pushViewController(webBrowser, animated: true)
        }
    }

}
