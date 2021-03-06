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
import SideMenu

class MainTableViewController: UITableViewController, mySuperProtocol {
    
    var uiController: UITableViewController!
    var feedController: CoreDataHelper!
    var favorited: Bool = false
    
    private let headerHeight: CGFloat = 50
    let maxItemsInFeed = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiController = self
        feedController = CoreDataHelper(rss: RSSHelper())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refresh()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return HeaderView(for: feedController.feedList[section], width: self.view.bounds.width, height: headerHeight, sender: (uiController, feedController))
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return feedController.feedList.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedController.feedItemsList[section].count < maxItemsInFeed ? feedController.feedItemsList[section].count : maxItemsInFeed
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedItem", for: indexPath) as! FeedItemCell
            
        cell.nameItemLabel.text = feedController.feedItemsList[indexPath.section][indexPath.row].title
        cell.infoItemLabel.text = feedController.feedItemsList[indexPath.section][indexPath.row].description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webBrowser = SwiftWebVC(urlString: feedController.feedItemsList[indexPath.section][indexPath.row].link!)
        self.navigationController?.pushViewController(webBrowser, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
        refresh()
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        editFeedNameAlert(name: "", url: "")
        refresh()
    }
    
    @IBAction func refresherAction(_ sender: UIRefreshControl) {
        sender.endRefreshing()
        refresh()
    }
}

extension MainTableViewController: UISideMenuNavigationControllerDelegate {
    
    func sideMenuWillDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        
        if let controller = menu.viewControllers.first as? SideBarTableViewController {
            if let index = controller.indexStart {
                favorited = false
                refresh()
                
                DispatchQueue.main.async {
                    self.tableView.scrollToRow(at: index, at: .top, animated: true)
                }
                
            } else {
                favorited = controller.favorited
                refresh()
            }
        }
        
    }
    
}
